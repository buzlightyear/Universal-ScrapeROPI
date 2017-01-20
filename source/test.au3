#include <GDIPlus.au3>
#include <Misc.au3>

Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 1)

Global $user32_dll = DllOpen("user32.dll")
Global $Reset, $hPenDotted, $hPenDash, $ResetCube, $CubeX, $CubeY, $CubeZ
Global $CubeX1, $CubeY1, $CubeX2, $CubeY2, $CubeX3, $CubeY3, $CubeX4, $CubeY4
Global $Tog, $Tog1, $Tog2, $Tog3, $Tog4 = True, $Tog5, $Tog6, $Tog7 = True, $T, $Delay = 100
Global $Text = "Press F1 to F6 to Toogle Cube Faces (F7 Toggles the Autoit Logo being Painted)"
Global $text1 = "Left Mouse Button to Rotate, Right Mouse Button to Reset (Mouse wheel to Zoom)"

Local $dot_distance = 150
Local Const $Width = 600
Local Const $Height = $Width
Local Const $W2 = $Width / 2
Local Const $H2 = $Height / 2
Local Const $deg = 180 / ACos(-1)
Local $hwnd = GUICreate("Orginal Code by UEZ ", $Width, $Height)

GUISetState()

If @OSBuild < 7600 Then WinSetTrans($hwnd, "", 0xFF) ;workaround for XP machines when alpha blending is activated on _GDIPlus_GraphicsClear() function to avoid slow drawing

_GDIPlus_Startup()
Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hwnd)
Local $hBitmap = _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $hGraphics)
Local $hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsClear($hBackbuffer)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

Local $sAutoItPath = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt', 'InstallDir')
Local $hImage = _GDIPlus_ImageLoadFromFile($sAutoItPath & "\Examples\GUI\logo4.gif")

Local $Str
Local $pColor = 0xFF0000F0
Local $hPen = _GDIPlus_PenCreate($pColor, 8)
_GDIPlus_PenSetEndCap($hPen, $GDIP_LINECAPARROWANCHOR)
Local $hCubePen = _GDIPlus_PenCreate(0x400000F0, 8)
_GDIPlus_PenSetEndCap($hCubePen, $GDIP_LINECAPARROWANCHOR)
Local $hBrush = _GDIPlus_BrushCreateSolid()
Local $hBrush1 = _GDIPlus_BrushCreateSolid(0x60FFFF00)
Local $hBrush2 = _GDIPlus_BrushCreateSolid(0x60FF8000)
$hPenDash = _GDIPlus_PenCreate(0xFF000000, 2)
_GDIPlus_PenSetDashStyle($hPenDash, $GDIP_DASHSTYLEDASH)
$hPenDotted = _GDIPlus_PenCreate(0xFF000000, 2)
_GDIPlus_PenSetDashStyle($hPenDotted, $GDIP_DASHSTYLEDOT)
Local Const $length = 250
Local Const $Pi = ACos(-1)
Local Const $amout_of_dots = 6
Local Const $amout_of_cube_dots = 9

#cs
    X           Y           Z
    ---------------------------------------
    1    [-$length,     0,          0 ], _
    2    [ $length,     0,          0 ], _
    3    [  0,      -$length,       0 ], _
    4    [  0,       $length,       0 ], _
    5    [  0,          0,      -$length ], _
    6    [  0,          0,       $length ]]
#ce

; Axis Coords
Local $draw_coordinates[$amout_of_dots][4] = [ _;   X                   y                   Z
        [-$length, 0, 0], _
        [$length, 0, 0], _
        [0, -$length, 0], _
        [0, $length, 0], _
        [0, 0, -$length], _
        [0, 0, $length]]
$Reset = $draw_coordinates

Local $cube_coordinates[$amout_of_cube_dots][4] = [ _;  X                   y                   Z
        [-$dot_distance, -$dot_distance, -$dot_distance], _
        [$dot_distance, -$dot_distance, -$dot_distance], _
        [$dot_distance, $dot_distance, -$dot_distance], _
        [-$dot_distance, $dot_distance, -$dot_distance], _
        [-$dot_distance, -$dot_distance, $dot_distance], _
        [$dot_distance, -$dot_distance, $dot_distance], _
        [$dot_distance, $dot_distance, $dot_distance], _
        [-$dot_distance, $dot_distance, $dot_distance]]
$ResetCube = $cube_coordinates


Local $x1, $y1, $x2, $y2
Local $b, $j, $x, $y, $z, $mx, $my, $MPos
Local $zoom_counter = 100
Local Const $zoom_min = 50
Local Const $zoom_max = 125
Local Const $mouse_sense = 4000
Local Const $start_x = $Width / 2
Local Const $start_y = $Height / 2
Local Const $dx = @DesktopWidth / 2, $dy = @DesktopHeight / 2
Local Const $Red = 0xFFF00000
Local Const $Green = 0xFF00F000
Local Const $Blue = 0xFF0000F0
Local $mwx, $mwy, $mwz, $angle, $rad = 180 / $Pi

MouseMove($dx, $dy, 1)

GUIRegisterMsg(0x020A, "WM_MOUSEWHEEL")

GUISetOnEvent(-3, "Close")

Do
    _GDIPlus_GraphicsClear($hBackbuffer, 0xF0FFFFFF)

    For $b = 0 To $amout_of_dots - 1 ;correct axis perspective
        $draw_coordinates[$b][3] = 1 + $draw_coordinates[$b][2] / 1500
    Next
    For $c = 0 To $amout_of_cube_dots - 1 ;correct  cube perspective
        $cube_coordinates[$c][3] = 1 + $cube_coordinates[$c][2] / 0x600
    Next

    ;draw axis lines
    Draw_Lines(0, 1, $Red) ;draw x axis - red
    Draw_Lines(2, 3, $Green) ;draw y axis - green
    Draw_Lines(4, 5, $Blue) ;draw z axis - blue
    ;--------------------------------------------------------------------

    Select
        Case _IsPressed("70", $user32_dll)
            Sleep($Delay)
            $Tog1 = Not $Tog1
            ;       Beep(100,50)

        Case _IsPressed("71", $user32_dll)
            Sleep($Delay)
            $Tog2 = Not $Tog2
            ;       Beep(200,50)

        Case _IsPressed("72", $user32_dll)
            Sleep($Delay)
            $Tog3 = Not $Tog3
            ;       Beep(300,50)

        Case _IsPressed("73", $user32_dll)
            Sleep($Delay)
            $Tog4 = Not $Tog4
            ;       Beep(400,50)

        Case _IsPressed("74", $user32_dll)
            Sleep($Delay)
            $Tog5 = Not $Tog5
            ;       Beep(500,50)

        Case _IsPressed("75", $user32_dll)
            Sleep($Delay)
            $Tog6 = Not $Tog6
            ;       Beep(600,50)

        Case _IsPressed("76", $user32_dll)
            Sleep($Delay)
            $Tog7 = Not $Tog7
            ;       Beep(700,50)
    EndSelect

    ;       4 -- - - - 5
    ;     / |        / |
    ;    0 - -  - - 1  |
    ;    |  |       |  |
    ;    |  7 -- - -|- 6
    ;    | /        | /
    ;    3 - -  - - 2
    If $Tog1 = True Then Draw_Cube_Lines(3, 2, 6, 7) ;F1 bottom
    If $Tog2 = True Then Draw_Cube_Lines(5, 1, 0, 4) ;F2 top
    If $Tog3 = True Then Draw_Cube_Lines(1, 2, 3, 0) ;F3 front
    If $Tog4 = True Then Draw_Cube_Lines(7, 6, 5, 4) ;F4 rear
    If $Tog5 = True Then Draw_Cube_Lines(6, 2, 1, 5) ;F5 right
    If $Tog6 = True Then Draw_Cube_Lines(0, 3, 7, 4) ;F6 left

    If _IsPressed("01", $user32_dll) Then ; Left mouse button to Rotate
        $MPos = MouseGetPos()
        For $j = 0 To $amout_of_dots - 1
            $mx = ($dx - $MPos[0]) / $mouse_sense
            $my = -($dy - $MPos[1]) / $mouse_sense
            Calc($my, $mx, $j) ;calculate axis coordinates
        Next
        For $j = 0 To $amout_of_cube_dots - 1
            CubeCalc($my, $mx, $j) ;calculate cube coordinates
        Next
    EndIf
    If _IsPressed("02", $user32_dll) Then ;Right mouse button to Reset CoOrds and Toggles to inital values
        $draw_coordinates = $Reset
        $cube_coordinates = $ResetCube
        $Tog1 = False
        $Tog2 = False
        $Tog3 = False
        $Tog4 = True ;Draw this Face as Default
        $Tog5 = False
        $Tog6 = False
        $Tog7 = True ;Paint Logo
    EndIf

    _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, $Width, $Height)
Until Not Sleep(30)

;Draw Axis Lines
Func Draw_Lines($p1, $p2, $pColor)
    $x1 = $start_x + $draw_coordinates[$p1][0] * $draw_coordinates[$p1][3]
    $y1 = $start_y + $draw_coordinates[$p1][1] * $draw_coordinates[$p1][3]

    $x2 = $start_x + $draw_coordinates[$p2][0] * $draw_coordinates[$p2][3]
    $y2 = $start_y + $draw_coordinates[$p2][1] * $draw_coordinates[$p2][3]

    _GDIPlus_PenSetColor($hPen, $pColor)
    _GDIPlus_GraphicsDrawLine($hBackbuffer, $x1, $y1, $x2, $y2, $hPen)

    _GDIPlus_BrushSetSolidColor($hBrush, $pColor)
    _GDIPlus_GraphicsFillEllipse($hBackbuffer, $x1 - 10, $y1 - 10, 20, 20, $hBrush)

    $angle = Mod(360 - Abs(Angle($draw_coordinates[$p1][0], $draw_coordinates[$p2][1])), 360)
    Select
        Case $pColor = $Red
            $Str = "XAngle = " & StringFormat("%.2f", $angle)
        Case $pColor = $Green
            $Str = "YAngle = " & StringFormat("%.2f", $angle)
        Case $pColor = $Blue
            $Str = "ZAngle = " & StringFormat("%.2f", $angle)
    EndSelect
    _GDIPlus_GraphicsFillEllipse($hBackbuffer, $start_x - 10, $start_y - 10, 20, 20, 0) ; Origin
    _GDIPlus_GraphicsDrawString($hBackbuffer, "Origin", $start_x - 20, $start_y - 30)
    _GDIPlus_GraphicsDrawString($hBackbuffer, $Str, $x2 - 20, $y2 - 30)
EndFunc   ;==>Draw_Lines

Func Draw_Cube_Lines($Cp1, $Cp2, $Cp3, $Cp4)
    $CubeX1 = $start_x + $cube_coordinates[$Cp1][0] * $cube_coordinates[$Cp1][3]
    $CubeY1 = $start_y + $cube_coordinates[$Cp1][1] * $cube_coordinates[$Cp1][3]

    $CubeX2 = $start_x + $cube_coordinates[$Cp2][0] * $cube_coordinates[$Cp2][3]
    $CubeY2 = $start_y + $cube_coordinates[$Cp2][1] * $cube_coordinates[$Cp2][3]

    $CubeX3 = $start_x + $cube_coordinates[$Cp3][0] * $cube_coordinates[$Cp3][3]
    $CubeY3 = $start_y + $cube_coordinates[$Cp3][1] * $cube_coordinates[$Cp3][3]

    $CubeX4 = $start_x + $cube_coordinates[$Cp4][0] * $cube_coordinates[$Cp4][3]
    $CubeY4 = $start_y + $cube_coordinates[$Cp4][1] * $cube_coordinates[$Cp4][3]

    ;#######                    For Front Face              #########
    ;------------------------------- Top -------------------------------------------------------
    _GDIPlus_GraphicsDrawLine($hBackbuffer, $CubeX4, $CubeY4, $CubeX1, $CubeY1, $hCubePen) ; top 0 - 1
    _GDIPlus_GraphicsFillEllipse($hBackbuffer, $CubeX4 - 5, $CubeY4 - 5, 10, 10, 0)

    _GDIPlus_GraphicsDrawLine($hBackbuffer, $start_x, $start_y, $CubeX4, $CubeY4, $hPenDash)
    _GDIPlus_GraphicsDrawString($hBackbuffer, $Cp4, $CubeX4 - 10, $CubeY4 - 20, "Arial", 12)
    _GDIPlus_GraphicsDrawString($hBackbuffer, $Cp1, $CubeX1, $CubeY1 - 20, "Arial", 12)
    ;-------------------------------------------------------------------------------------------
    ;------------------------------- Right -------------------------------------------------------
    _GDIPlus_GraphicsDrawLine($hBackbuffer, $CubeX1, $CubeY1, $CubeX2, $CubeY2, $hCubePen) ; right 2 - 1
    ;---------------------------------------------------------------------------------------------
    ;------------------------------- Bottom -------------------------------------------------------
    _GDIPlus_GraphicsDrawLine($hBackbuffer, $CubeX2, $CubeY2, $CubeX3, $CubeY3, $hCubePen) ; bottom 3 - 2
    _GDIPlus_GraphicsFillEllipse($hBackbuffer, $CubeX2 - 5, $CubeY2 - 5, 10, 10, 0)

    _GDIPlus_GraphicsDrawLine($hBackbuffer, $start_x, $start_y, $CubeX2, $CubeY2, $hPenDash)
    _GDIPlus_GraphicsDrawString($hBackbuffer, $Cp2, $CubeX2 + 5, $CubeY2, "Arial", 12)
    _GDIPlus_GraphicsDrawString($hBackbuffer, $Cp3, $CubeX3 - 10, $CubeY3, "Arial", 12)
    ;----------------------------------------------------------------------------------------------
    _GDIPlus_GraphicsDrawString($hBackbuffer, $Text, 5, 550, "Arial", 12) ;Instructions
    _GDIPlus_GraphicsDrawString($hBackbuffer, $text1, 5, 570, "Arial", 12)

    ;------------------------------- Left --------------------------------------------------------
    _GDIPlus_GraphicsDrawLine($hBackbuffer, $CubeX3, $CubeY3, $CubeX4, $CubeY4, $hCubePen) ; left
    ;----------------------------------------------------------------------------------------------
    _GDIPlus_GraphicsDrawString($hBackbuffer, $Cp3, $CubeX3 - 10, $CubeY3, "Arial", 12)
    ;--------------------------- Put the Autoit Logo image on one Face ----------------------------------------------
    If $Cp1 = 7 And $Tog7 = True Then
        _GDIPlus_GraphicsDrawImage_4Points($hBackbuffer, $hImage, $CubeX4, $CubeY4, _
                $CubeX3, $CubeY3, _
                $CubeX1, $CubeY1, _
                $CubeX2, $CubeY2, 0.05)
    EndIf
EndFunc   ;==>Draw_Cube_Lines





Func _GDIPlus_GraphicsDrawImage_4Points($hGraphics, $hImage, $X1, $Y1, $X2, $Y2, $X3, $Y3, $X4, $Y4, $fPrecision = 0.25)
    ;by eukalyptus
    Local $aResult = DllCall($__g_hGDIPDll, "uint", "GdipCreatePath", "int", 0, "int*", 0)
    If @error Or Not IsArray($aResult) Then Return SetError(1, 1, False)
    Local $hPath = $aResult[2]

    Local $iW = _GDIPlus_ImageGetWidth($hImage)
    Local $iH = _GDIPlus_ImageGetHeight($hImage)

    If $fPrecision <= 0 Then $fPrecision = 0.01
    If $fPrecision > 1 Then $fPrecision = 1

    Local $iTX = Ceiling($iW * $fPrecision)
    Local $iTY = Ceiling($iH * $fPrecision)
    Local $iCnt = ($iTX + 1) * ($iTY + 1)
    Local $X, $Y

    Local $tPoints = DllStructCreate("float[" & $iCnt * 2 & "]")
    Local $I
    For $Y = 0 To $iTY
        For $X = 0 To $iTX
            $I = ($Y * ($iTX + 1) + $X) * 2
            DllStructSetData($tPoints, 1, $X * $iW / $iTX, $I + 1)
            DllStructSetData($tPoints, 1, $Y * $iH / $iTY, $I + 2)
        Next
    Next

    $aResult = DllCall($__g_hGDIPDll, "uint", "GdipAddPathPolygon", "hwnd", $hPath, "ptr", DllStructGetPtr($tPoints), "int", $iCnt)
    If @error Or Not IsArray($aResult) Then Return SetError(1, 2, False)

    Local $tWarp = DllStructCreate("float[8]")
    DllStructSetData($tWarp, 1, $X1, 1)
    DllStructSetData($tWarp, 1, $Y1, 2)
    DllStructSetData($tWarp, 1, $X2, 3)
    DllStructSetData($tWarp, 1, $Y2, 4)
    DllStructSetData($tWarp, 1, $X3, 5)
    DllStructSetData($tWarp, 1, $Y3, 6)
    DllStructSetData($tWarp, 1, $X4, 7)
    DllStructSetData($tWarp, 1, $Y4, 8)

    $aResult = DllCall($__g_hGDIPDll, "uint", "GdipWarpPath", "hwnd", $hPath, "hwnd", 0, "ptr", DllStructGetPtr($tWarp), "int", 4, "float", 0, "float", 0, "float", $iW, "float", $iH, "int", 0, "float", 0)
    If @error Or Not IsArray($aResult) Then Return SetError(1, 3, False)

    $aResult = DllCall($__g_hGDIPDll, "uint", "GdipGetPathPoints", "hwnd", $hPath, "ptr", DllStructGetPtr($tPoints), "int", $iCnt)
    If @error Or Not IsArray($aResult) Then Return SetError(1, 4, False)

    Local $tRectF = DllStructCreate("float X;float Y;float Width;float Height")
    $aResult = DllCall($__g_hGDIPDll, "uint", "GdipGetPathWorldBounds", "hwnd", $hPath, "ptr", DllStructGetPtr($tRectF), "hwnd", 0, "hwnd", 0)
    If @error Or Not IsArray($aResult) Then Return SetError(1, 5, False)

    DllCall($__g_hGDIPDll, "uint", "GdipDeletePath", "hwnd", $hPath)

    Local $hBitmap = _GDIPlus_BitmapCreateFromGraphics(DllStructGetData($tRectF, 1) + DllStructGetData($tRectF, 3), DllStructGetData($tRectF, 2) + DllStructGetData($tRectF, 4), $hGraphics)
    Local $hContext = _GDIPlus_ImageGetGraphicsContext($hBitmap)

    Local $tDraw = DllStructCreate("float[6]")
    Local $pDraw = DllStructGetPtr($tDraw)
    Local $W = $iW / $iTX
    Local $H = $iH / $iTY
    Local $iO = ($iTX + 1) * 2
    Local $fX1, $fY1, $fX2, $fY2, $fX3, $fY3, $fSX, $fSY

    For $Y = 0 To $iTY - 1
        For $X = 0 To $iTX - 1
            $I = ($Y * ($iTX + 1) + $X) * 2
            $fX1 = DllStructGetData($tPoints, 1, $I + 1)
            $fY1 = DllStructGetData($tPoints, 1, $I + 2)

            Switch $X
                Case $iTX - 1
                    $fX2 = DllStructGetData($tPoints, 1, $I + 3)
                    $fY2 = DllStructGetData($tPoints, 1, $I + 4)
                    $fSX = 1
                Case Else
                    $fX2 = DllStructGetData($tPoints, 1, $I + 5)
                    $fY2 = DllStructGetData($tPoints, 1, $I + 6)
                    $fSX = 2
            EndSwitch

            Switch $Y
                Case $iTY - 1
                    $fX3 = DllStructGetData($tPoints, 1, $I + 1 + $iO)
                    $fY3 = DllStructGetData($tPoints, 1, $I + 2 + $iO)
                    $fSY = 1
                Case Else
                    $fX3 = DllStructGetData($tPoints, 1, $I + 1 + $iO * 2)
                    $fY3 = DllStructGetData($tPoints, 1, $I + 2 + $iO * 2)
                    $fSY = 2
            EndSwitch

            DllStructSetData($tDraw, 1, $fX1, 1)
            DllStructSetData($tDraw, 1, $fY1, 2)
            DllStructSetData($tDraw, 1, $fX2, 3)
            DllStructSetData($tDraw, 1, $fY2, 4)
            DllStructSetData($tDraw, 1, $fX3, 5)
            DllStructSetData($tDraw, 1, $fY3, 6)

            DllCall($__g_hGDIPDll, "uint", "GdipDrawImagePointsRect", "hwnd", $hContext, "hwnd", $hImage, "ptr", $pDraw, "int", 3, "float", $X * $W, "float", $Y * $H, "float", $W * $fSX, "float", $H * $fSY, "int", 2, "hwnd", 0, "ptr", 0, "ptr", 0)
        Next
    Next

    _GDIPlus_GraphicsDispose($hContext)
    _GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 0, 0)
    _GDIPlus_BitmapDispose($hBitmap)
EndFunc   ;==>_GDIPlus_GraphicsDrawImage_4Points






Func Angle($x, $y)
    Local $angle
    If $x = 0 Then
        $angle = 0
    Else
        $angle = -ATan($y / - $x) * $deg
    EndIf
    If - $x < 0 Then
        $angle = -180 + $angle
    ElseIf - $x >= 0 And $y < 0 Then
        $angle = -360 + $angle
    EndIf
    Return $angle
EndFunc   ;==>Angle

Func Calc($angle_x, $angle_y, $I, $angle_z = 0)
    ;calculate axis 3D rotation
    $x = $draw_coordinates[$I][0] * Cos($angle_y) + $draw_coordinates[$I][2] * Sin($angle_y)
    $y = $draw_coordinates[$I][1]
    $z = -$draw_coordinates[$I][0] * Sin($angle_y) + $draw_coordinates[$I][2] * Cos($angle_y)

    $draw_coordinates[$I][0] = $x
    $draw_coordinates[$I][1] = $y * Cos($angle_x) - $z * Sin($angle_x)
    $draw_coordinates[$I][2] = $y * Sin($angle_x) + $z * Cos($angle_x)
EndFunc   ;==>Calc

Func CubeCalc($angle_x, $angle_y, $I)
    ;calculate Cube 3D rotation
    $CubeX = $cube_coordinates[$I][0] * Cos($angle_y) + $cube_coordinates[$I][2] * Sin($angle_y)
    $CubeY = $cube_coordinates[$I][1]
    $CubeZ = -$cube_coordinates[$I][0] * Sin($angle_y) + $cube_coordinates[$I][2] * Cos($angle_y)

    $cube_coordinates[$I][0] = $CubeX
    $cube_coordinates[$I][1] = $CubeY * Cos($angle_x) - $CubeZ * Sin($angle_x)
    $cube_coordinates[$I][2] = $CubeY * Sin($angle_x) + $CubeZ * Cos($angle_x)
EndFunc   ;==>CubeCalc

Func Close()
    _GDIPlus_BrushDispose($hBrush1)
    _GDIPlus_BrushDispose($hBrush2)
    _GDIPlus_PenDispose($hPen)
    _GDIPlus_PenDispose($hPenDash)
    _GDIPlus_PenDispose($hPenDotted)
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_GraphicsDispose($hBackbuffer)
    _GDIPlus_GraphicsDispose($hGraphics)
    _GDIPlus_Shutdown()
    DllClose($user32_dll)
    Exit
EndFunc   ;==>Close

Func Zoom($factor)
    Local $m
    For $m = 0 To $amout_of_dots - 1
        $draw_coordinates[$m][0] *= $factor
        $draw_coordinates[$m][1] *= $factor
        $draw_coordinates[$m][2] *= $factor
    Next
    For $m = 0 To $amout_of_cube_dots - 1
        $cube_coordinates[$m][0] *= $factor
        $cube_coordinates[$m][1] *= $factor
        $cube_coordinates[$m][2] *= $factor
    Next
EndFunc   ;==>Zoom

Func WM_MOUSEWHEEL($hwnd, $iMsg, $wParam, $lParam)
    Local $wheel_Dir = BitAND($wParam, 0x800000)
    If $wheel_Dir > 0 Then
        If $zoom_counter <= $zoom_max Then
            Zoom(1.05)
            $zoom_counter += 1
        EndIf
    Else
        If $zoom_counter >= $zoom_min Then
            Zoom(0.95)
            $zoom_counter -= 1
        EndIf
    EndIf
    Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_MOUSEWHEEL