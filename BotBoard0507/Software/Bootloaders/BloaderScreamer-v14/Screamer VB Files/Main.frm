VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form Main 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Screamer v1.4"
   ClientHeight    =   3420
   ClientLeft      =   6555
   ClientTop       =   3915
   ClientWidth     =   5100
   Icon            =   "Main.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   3420
   ScaleWidth      =   5100
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "&Open"
      Height          =   375
      Left            =   360
      TabIndex        =   0
      Top             =   960
      Width           =   1455
   End
   Begin VB.CommandButton cmdBreak 
      Caption         =   "&Stop Waiting"
      Enabled         =   0   'False
      Height          =   375
      Left            =   3240
      TabIndex        =   2
      Top             =   960
      Width           =   1455
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   3960
      MultiLine       =   -1  'True
      TabIndex        =   8
      Text            =   "Main.frx":0ECA
      Top             =   2880
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Frame Frame1 
      Caption         =   "Source File (HEX)"
      Height          =   735
      Left            =   360
      TabIndex        =   7
      Top             =   120
      Width           =   4335
      Begin VB.TextBox txtFileName 
         Height          =   375
         Left            =   120
         TabIndex        =   3
         Top             =   240
         Width           =   4095
      End
   End
   Begin VB.CommandButton cmdDownload 
      Caption         =   "&Download"
      Height          =   375
      Left            =   1800
      TabIndex        =   1
      Top             =   960
      Width           =   1455
   End
   Begin MSComDlg.CommonDialog cd1 
      Left            =   3360
      Top             =   2760
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   2640
      Top             =   2640
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      CommPort        =   3
      DTREnable       =   -1  'True
      InBufferSize    =   3
      InputLen        =   3
      RTSEnable       =   -1  'True
   End
   Begin VB.Label lblDownload 
      Caption         =   "Idle"
      Height          =   255
      Left            =   600
      TabIndex        =   13
      Top             =   3000
      Width           =   1575
   End
   Begin VB.Shape sptComplete 
      FillColor       =   &H000000FF&
      FillStyle       =   0  'Solid
      Height          =   255
      Left            =   120
      Shape           =   3  'Circle
      Top             =   3000
      Width           =   255
   End
   Begin VB.Shape sptDownload 
      FillColor       =   &H000000FF&
      FillStyle       =   0  'Solid
      Height          =   255
      Left            =   120
      Shape           =   3  'Circle
      Top             =   2640
      Width           =   255
   End
   Begin VB.Shape sptConnect 
      FillColor       =   &H000000FF&
      FillStyle       =   0  'Solid
      Height          =   255
      Left            =   120
      Shape           =   3  'Circle
      Top             =   2280
      Width           =   255
   End
   Begin VB.Label lblRetries 
      Caption         =   "Retries:"
      Height          =   255
      Left            =   600
      TabIndex        =   12
      Top             =   2640
      Width           =   615
   End
   Begin VB.Label lblResend 
      Caption         =   "0"
      Height          =   255
      Left            =   1320
      TabIndex        =   11
      Top             =   2640
      Width           =   1095
   End
   Begin VB.Label lblStatus 
      Caption         =   "Idle"
      Height          =   255
      Left            =   1200
      TabIndex        =   10
      Top             =   2280
      Width           =   3855
   End
   Begin VB.Label lblStat 
      Caption         =   "Status:"
      Height          =   255
      Left            =   600
      TabIndex        =   9
      Top             =   2280
      Width           =   495
   End
   Begin VB.Label lblDownloadBarFG 
      BackColor       =   &H00800000&
      Height          =   255
      Left            =   240
      TabIndex        =   6
      Top             =   1800
      Width           =   375
   End
   Begin VB.Label lblCurrentBuffer 
      Caption         =   "Buffer Empty"
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   240
      TabIndex        =   5
      Top             =   1440
      Width           =   4695
   End
   Begin VB.Label lblDownloadBarBG 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   1  'Fixed Single
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   240
      TabIndex        =   4
      Top             =   1800
      Width           =   4695
   End
   Begin VB.Menu File_Menu 
      Caption         =   "&File"
      Begin VB.Menu File_Open 
         Caption         =   "Open HEX"
      End
      Begin VB.Menu Spacer 
         Caption         =   "------"
      End
      Begin VB.Menu File_Close 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu Menu_Comm 
      Caption         =   "&Comm"
      Begin VB.Menu DataPort 
         Caption         =   "Comm 1"
         Index           =   1
      End
      Begin VB.Menu DataPort 
         Caption         =   "Comm 2"
         Index           =   2
      End
      Begin VB.Menu DataPort 
         Caption         =   "Comm 3"
         Index           =   3
      End
      Begin VB.Menu DataPort 
         Caption         =   "Comm 4"
         Index           =   4
      End
      Begin VB.Menu DataPort 
         Caption         =   "Comm 5"
         Index           =   5
      End
      Begin VB.Menu DataPort 
         Caption         =   "Comm 6"
         Index           =   6
      End
   End
   Begin VB.Menu Menu_Baud 
      Caption         =   "&Baud"
      Begin VB.Menu DataSpeed 
         Caption         =   "9600"
         Index           =   1
      End
      Begin VB.Menu DataSpeed 
         Caption         =   "19200"
         Index           =   2
      End
      Begin VB.Menu DataSpeed 
         Caption         =   "38400"
         Index           =   3
      End
      Begin VB.Menu DataSpeed 
         Caption         =   "57600"
         Index           =   4
      End
      Begin VB.Menu DataSpeed 
         Caption         =   "115200"
         Index           =   5
      End
   End
   Begin VB.Menu Menu_Chip 
      Caption         =   "Chip"
      Begin VB.Menu ChipType 
         Caption         =   "16F877A"
         Index           =   1
      End
      Begin VB.Menu ChipType 
         Caption         =   "16F876A"
         Index           =   2
      End
      Begin VB.Menu ChipType 
         Caption         =   "16F873A"
         Index           =   3
      End
      Begin VB.Menu ChipType 
         Caption         =   "16F88"
         Index           =   4
      End
   End
   Begin VB.Menu Menu_Osc 
      Caption         =   "&Oscillator"
      Begin VB.Menu Osc 
         Caption         =   "20MHz"
         Index           =   1
      End
      Begin VB.Menu Osc 
         Caption         =   "8MHz"
         Index           =   2
      End
      Begin VB.Menu Osc 
         Caption         =   "4MHz"
         Index           =   3
      End
   End
   Begin VB.Menu About_Menu 
      Caption         =   "&About"
   End
End
Attribute VB_Name = "Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Option Explicit

' 1-20-04 v1.0
' 1-21-04 New v1.1 Added boot vector redirection to memory location 4

' 2-12-04 New v1.2 Added baud rate control.
          'Fixed the glitch - when the config word was seen, it was higher
          'then the bootloader, and erroneusly reported the HEX file as
          'being too large.
          'Added a settings file - Screamer now remembers your settings!

' 5-20-04 New v1.3 Added better boot loader protection
        'Bloader now transmits the absolute location of the boot loader
        'Screamer will not write anything above this address.
        
' 6-10-04 v1.4 Added chip selection so that we can control the boot vector load


Dim CommPort As Integer
Dim CommSpeed As Double
Dim PICSpeed As Double
Dim OscSetting As Integer

Dim Chip_Type As String

Dim Stop_Waiting As Boolean
Dim timeoutFlag As Boolean

Dim txtUserFile As String

Private Sub About_Menu_Click()
    frmAbout.Show
End Sub

Private Sub ChipType_Click(Index As Integer)
    ChipType(1).Checked = False
    ChipType(2).Checked = False
    ChipType(3).Checked = False
    ChipType(4).Checked = False
    ChipType(Index).Checked = True
    
    Chip_Type = ChipType(Index).Caption

End Sub

Private Sub cmdBreak_Click()
    
    Stop_Waiting = True

End Sub

Private Sub cmdBrowse_Click()
    
    'Open a file dialog and let the user select a HEX file
    cd1.Filter = "Hex Files (*.HEX)|*.HEX| All Files (*.*)|*.*"
    cd1.FilterIndex = 1
    cd1.DialogTitle = "Select a file "

    cd1.ShowOpen
    If cd1.FileName <> "" Then
        txtFileName.Text = cd1.FileName
        txtUserFile = cd1.FileName
    End If

End Sub

Function RoundNear(varNumber As Variant, varDelta As Variant) As Variant
'***********
'Name:      RoundNear (Function)
'Purpose:   rounds varnumber to the nearest fraction equal
'   varDelta
'Inputs:    varNumber - number to round
'           varDelta - the fraction used as measure of
'   rounding
'Example:   RoundNear(53,6) = 54
'           RoundNear(1.16,0.25) = 1.25
'           RoundNear(1.12,0.25) = 1.00
'           RoundNear(1.125,0.25)= 1.25
'Output:    varNumber rounded to nearest
'           multiple of varDelta.
'***********

 Dim varDec As Variant
 Dim intX As Integer
 Dim varX As Variant
 
 varX = varNumber / varDelta
 intX = Int(varX)
 varDec = CDec(varX) - intX
 
 If varDec >= 0.5 Then
   RoundNear = varDelta * (intX + 1)
 Else
   RoundNear = varDelta * intX
 End If
End Function

Private Sub cmdDownload_Click()

'On Error GoTo ErrHandler
    
Dim outBuffer
Dim totalLen, currentLen
Dim fnum As Integer
Dim fileContentLines() As String
Dim i As Long
Dim j As Integer
    
Dim nate As String
Dim temp As Integer

Dim Record_Length As Integer

Dim DownloadSpeed As Integer

Dim Memory_Address_High As Integer
Dim Memory_Address_Low As Integer

Dim End_Record As Integer
Dim Outgoing_Data(50) As Integer
Dim Check_Sum As Integer

Dim Bloader_Start_High As Integer
Dim Bloader_Start_Low As Integer
'Dim Bloader_Jump_Low As Integer

Dim User_Boot_Vector_High As Integer
Dim User_Boot_Vector_Low As Integer

Dim Total_Code_Words As Integer

    'Reset the user break command
    Stop_Waiting = False
    Total_Code_Words = 0
    lblDownload.Caption = "Downloading..."
    
    'If port already opened then close it
    If MSComm1.PortOpen = True Then
        MSComm1.PortOpen = False
    End If
    
    'Read in the HEX file - clean it up
    If txtFileName.Text <> "" Then
        fnum = FreeFile()
        Open txtFileName.Text For Input As #fnum
        
        'Read each line into fileContentLines() array
        fileContentLines() = Split(Input(LOF(fnum), fnum), vbCrLf)
        Close #fnum
        
        'Remove empty lines + lines not starting with a ":"
        For i = 0 To UBound(fileContentLines)
            If Len(fileContentLines(i)) = 0 Then fileContentLines(i) = vbNullChar
            If Left(fileContentLines(i), 1) <> ":" Then fileContentLines(i) = vbNullChar
        Next
        
        fileContentLines() = Filter(fileContentLines(), vbNullChar, False)
        totalLen = UBound(fileContentLines)
        
    Else
        MsgBox "Error, no HEX file found", vbOKOnly
        Exit Sub
    End If

    sptConnect.FillColor = &HFF&
    sptDownload.FillColor = &HFF&
    sptComplete.FillColor = &HFF&
    
    lblResend.Caption = 0
    lblDownload.Caption = "Running..."
    
    'Calculate download speed
    'This is the SPBRG register value that will be sent to the PIC
    DownloadSpeed = RoundNear(PICSpeed * 1000000 / (16 * CommSpeed) - 1, 0.25)
    'MsgBox DownloadSpeed
    'Exit Sub
    
    'Check to see if the PIC is outputting the load key ASC(5)
    lblStatus.Caption = "Waiting for PIC boot broadcast"
    MSComm1.CommPort = CommPort
    MSComm1.InputLen = 1
    MSComm1.Settings = "9600,n,8,1"
    MSComm1.PortOpen = True
    
    'Disable certain buttons
    cmdDownload.Enabled = False
    cmdBrowse.Enabled = False
    cmdBreak.Enabled = True
    cmdBreak.Caption = "&Stop Waiting"
    Do While MSComm1.Input <> Chr(5)
        
        'See if user wants to stop
        If Stop_Waiting = True Then
            MsgBox "The PIC did not enter load mode.", vbOKOnly
        
            lblStatus.Caption = "Idle"
            lblDownload.Caption = "Idle"
            cmdDownload.Enabled = True
            cmdBreak.Enabled = False
            cmdBrowse.Enabled = True
         
            Exit Sub
        End If
        
        DoEvents
            
    Loop
    cmdBreak.Caption = "Abort"

    'Output 6 to cause the PIC to go into load mode
    lblStatus.Caption = "Load Mode Command Sent"
    sptConnect.FillColor = &HFF00& 'Green
    MSComm1.Output = Chr(6)

    'Transmit the user's download speed
    MSComm1.Output = Chr(DownloadSpeed)
    
    'Now move to the new speed
    If CommSpeed <> "9600" Then
        MSComm1.PortOpen = False
        MSComm1.Settings = CommSpeed & ",n,8,1"
        MSComm1.PortOpen = True
    End If
    
    'Snag the bloader starting memory location info from PIC
    Do While MSComm1.InBufferCount < 2
        'See if user wants to stop
        If Stop_Waiting = True Then
            MsgBox "The PIC did not finish loading. You will likely experience unexpected program execution.", vbOKOnly
            
            lblStatus.Caption = "Idle"
            lblDownload.Caption = "Idle"
            cmdDownload.Enabled = True
            cmdBreak.Enabled = False
            cmdBrowse.Enabled = True
            
            Exit Sub
        End If
        
        DoEvents
    Loop
    Bloader_Start_High = Asc(MSComm1.Input) '31 '0x1F
    Bloader_Start_Low = Asc(MSComm1.Input)
    'Bloader_Jump_Low = Asc(MSComm1.Input)

    For i = 0 To UBound(fileContentLines)
        
        'See if user wants to stop
        If Stop_Waiting = True Then
            MsgBox "The PIC did not finish loading. You will likely experience unexpected program execution.", vbOKOnly
            
            lblStatus.Caption = "Idle"
            lblDownload.Caption = "Idle"
            cmdDownload.Enabled = True
            cmdBreak.Enabled = False
            cmdBrowse.Enabled = True
            
            Exit Sub
        End If
        
        'Wait for PIC to tell us he's ready
        Do While MSComm1.InBufferCount = 0
            DoEvents
        
            'See if user has aborted - most likely freeze error
            If Stop_Waiting = True Then
                MsgBox "The PIC did not finish loading. You will likely experience unexpected program execution.", vbOKOnly
                
                lblStatus.Caption = "Idle"
                lblDownload.Caption = "Idle"
                cmdDownload.Enabled = True
                cmdBreak.Enabled = False
                cmdBrowse.Enabled = True
                
                Exit Sub
            End If
            
        Loop
        
        Text1 = MSComm1.Input
        
        If Text1 = "T" Then 'All is well
            sptDownload.FillColor = &HFF00& 'Green
            Total_Code_Words = Total_Code_Words + (Record_Length / 2)
        ElseIf Text1 = Chr(7) Then 'Re-send line
            i = i - 1
            lblResend.Caption = lblResend.Caption + 1
            sptDownload.FillColor = &HFFFF& 'Yellow
            DoEvents
        Else
            MsgBox "Error : Incorrect response - " & Text1 & " from PIC. Programming is incomplete and will now halt."
            
            lblStatus.Caption = "Idle"
            lblDownload.Caption = "Idle"
            cmdDownload.Enabled = True
            cmdBreak.Enabled = False
            cmdBrowse.Enabled = True
        
            Exit Sub
        End If
        
Hard_Coded_Next_line:

        'Pull the next line from the file
        'i = 0
        outBuffer = fileContentLines(i)
        lblCurrentBuffer.Caption = fileContentLines(i)
    
        'Do the fancy GUI updates
        lblStatus.Caption = "Loaded " & Total_Code_Words & " code words"
        lblDownloadBarFG.Width = lblDownloadBarBG.Width * (i / totalLen)
    
        'Here is where we rearrange data for direct sending
        '=============================================
        Text1.Text = fileContentLines(i)
        
        'Peel off ':'
        Text1 = Right(Text1, Len(Text1) - 1)
        
        'Peel off record length
        Record_Length = Hex_Convert(Left(Text1, 2))
        Text1 = Right(Text1, Len(Text1) - 2)
        'Catch a record length that is less than a multiple of 8
        Dim Length_Padding As Integer
        Length_Padding = 0
        Do While ((Record_Length + Length_Padding) Mod 8) <> 0
            Length_Padding = Length_Padding + 1
        Loop
        
        'Peel off memory address
        Memory_Address_High = Hex_Convert(Left(Text1, 2))
        Text1 = Right(Text1, Len(Text1) - 2)
        Memory_Address_Low = Hex_Convert(Left(Text1, 2))
        Text1 = Right(Text1, Len(Text1) - 2)
        
        'Divide Memory address by 2
        If (Memory_Address_High Mod 2) <> 0 Then Memory_Address_Low = Memory_Address_Low + 256
        Memory_Address_High = Memory_Address_High \ 2
        Memory_Address_Low = Memory_Address_Low \ 2
        
        'If this memory address is in the boot loader memory space, skip it!
        If Memory_Address_High = Bloader_Start_High Then
            If Memory_Address_Low >= Bloader_Start_Low - 8 Then
                
                If lblDownload.Caption <> "HEX File too long" Then
                    lblDownload.Caption = "HEX File too long"
                    MsgBox "This HEX File spills over into reserved Bloader space. You may experience unexpected program execution."
                    MsgBox "Stopping boot load!"
                    GoTo ErrExit
                    
                End If
                i = i + 1
                GoTo Hard_Coded_Next_line
                
            End If
        End If
        'If this memory address is in the config word space, skip it!
        If Memory_Address_High >= 32 Then '32 = 0x20 = 0x40 / 2
            i = i + 1
            GoTo Hard_Coded_Next_line
        End If
        
        '============================================================
        
        'Peel off and check for end of file tage
        End_Record = Hex_Convert(Left(Text1, 2))
        Text1 = Right(Text1, Len(Text1) - 2)
        If End_Record = 1 Then
            GoTo Last_Line
        End If
        
        'Calculate our OWN Checksum
        Check_Sum = Record_Length + Length_Padding + Memory_Address_High + Memory_Address_Low
        
        'Load program data into the outgoing_data array
        For j = 0 To (Record_Length / 2) - 1
            
            'Catch first byte and store it in second spot
            Outgoing_Data((j * 2) + 1) = Hex_Convert(Left(Text1, 2))
            Text1 = Right(Text1, Len(Text1) - 2)
            
            'Catch second byte and store it in first spot
            Outgoing_Data(j * 2) = Hex_Convert(Left(Text1, 2))
            Text1 = Right(Text1, Len(Text1) - 2)
            
            'This is the very special case of the boot vector
            'Memory location 0 should be a goto main
            'We will insert the bloader jump vector and shift the goto main to
            'memory location 4
            If Memory_Address_High = 0 And Memory_Address_Low = 0 Then
                'Make sure the user has created the HEX file properly with
                'the required pragma origin statement
                If Record_Length <> 2 Then
                    MsgBox "This HEX file does not appear to have the correct goto statement. Please double check that the proper 'origin 4' statement has been inserted at the beginning of the C program."
                    GoTo ErrExit
                End If
                
                'Originally we broadcasted the entire boot vector to the PIC. This has since
                'been moved to the PIC so that the boot vector is ALWAYS written during
                'a boot load so that we don't run the risk of losing it.
                
                '6-10-04 While this protected boot vector worked great for the 16F88, it causes the 16F87xA series
                'to overwrite the boot vector... So now we need a chip select! Great...
                
                If Chip_Type = "16F88" Then
                    'Repoint initial user's goto
                    Outgoing_Data(6) = Outgoing_Data(0)
                    Outgoing_Data(7) = Outgoing_Data(1)
                    '0x158A
                    Outgoing_Data(0) = Hex_Convert("3F")
                    Outgoing_Data(1) = Hex_Convert("FF")
                    '0x160A
                    Outgoing_Data(2) = Hex_Convert("3F")
                    Outgoing_Data(3) = Hex_Convert("FF")
                    '0x2F99
                    Outgoing_Data(4) = Hex_Convert("3F")
                    Outgoing_Data(5) = Hex_Convert("FF")
                ElseIf Chip_Type = "16F877A" Or Chip_Type = "16F876A" Or Chip_Type = "16F873A" Then
                    'Repoint initial user's goto
                    Outgoing_Data(6) = Outgoing_Data(0)
                    Outgoing_Data(7) = Outgoing_Data(1)
                    '0x158A
                    Outgoing_Data(0) = Hex_Convert("15")
                    Outgoing_Data(1) = Hex_Convert("8A")
                    '0x160A
                    Outgoing_Data(2) = Hex_Convert("16")
                    Outgoing_Data(3) = Hex_Convert("0A")
                    '0x2F40
                    Outgoing_Data(4) = Hex_Convert("2F")
                    Outgoing_Data(5) = Hex_Convert("40")
                End If
                
                
                'Fix Checksum
                Check_Sum = Check_Sum + Outgoing_Data(2) + Outgoing_Data(3) + Outgoing_Data(4) + Outgoing_Data(5) + Outgoing_Data(6) + Outgoing_Data(7)
                'Reset padding
                Length_Padding = 0
                Record_Length = 8
            End If
            
            Check_Sum = Check_Sum + Outgoing_Data(j * 2)
            Check_Sum = Check_Sum + Outgoing_Data((j * 2) + 1)
        Next
        
        'Add padding if this hex line is less than a multiple of 4
        For j = (Record_Length / 2) To (Length_Padding / 2) + (Record_Length / 2) - 1
            
            'Add padding
            Outgoing_Data(j * 2) = 63 '3F
            Outgoing_Data((j * 2) + 1) = 255 'FF
            
            Check_Sum = Check_Sum + Outgoing_Data(j * 2)
            Check_Sum = Check_Sum + Outgoing_Data((j * 2) + 1)
        Next
        
        'Now reduce check_sum to 8 bits
        Do While Check_Sum >= 256
            Check_Sum = Check_Sum - 256
        Loop
        'Now take 2's compliment
        Check_Sum = 256 - Check_Sum
        'Catch the special case
        If Check_Sum = 256 Then Check_Sum = 0
        
        '=============================================
        'Send the start character
        MSComm1.Output = ":"
        
        'Send the record length
        MSComm1.Output = Chr(Record_Length + Length_Padding)
        
        'Send this block's address
        MSComm1.Output = Chr(Memory_Address_High)
        MSComm1.Output = Chr(Memory_Address_Low)
        
        'Send this block's check sum
        MSComm1.Output = Chr(Check_Sum)
        
        'Send the block
        For j = 0 To (Record_Length + Length_Padding) - 1
            MSComm1.Output = Chr(Outgoing_Data(j))
        Next
        '=============================================
            
    Next
        
Last_Line:
    'Tell the PIC we are done transmitting data
    MSComm1.Output = ":"
    MSComm1.Output = "S"
    
    lblDownload.Caption = "Download Complete!"
    sptComplete.FillColor = &HFF00& 'Green
    sptConnect.FillColor = &HFF00& 'Green '&HFFFF& 'Yellow
        
    'Turn on the browse button
    cmdBrowse.Enabled = True
    cmdDownload.Enabled = True
    cmdBreak.Enabled = False
    
    'If port already opened then close it
    If MSComm1.PortOpen = True Then
        MSComm1.PortOpen = False
    End If

    Exit Sub

ErrHandler:
    If Err.Number = 8020 Or Err.Number = 8015 Then
        MsgBox "The PIC seems to be using the UART at a different baud rate. Please power down the PIC or hold it in reset before initiating download."
    Else
        MsgBox "Error, " & Err.Description, vbOKOnly
        MsgBox Err.Number
    End If

ErrExit:
    
    
    'If port already opened then close it
    If MSComm1.PortOpen = True Then
        MSComm1.PortOpen = False
    End If
    
    cmdDownload.Enabled = True
    cmdBrowse.Enabled = True
    cmdBreak.Enabled = False
    
    lblStatus.Caption = "Error"
    lblCurrentBuffer.Caption = "Buffer Empty"
    lblDownload.Caption = "Idle"
        

End Sub

Public Function Hex_Convert(nate As String) As Integer
'This function takes a two character string and converts it to an integer
Dim new_hex As Long
Dim temp As Integer
Dim i As Integer
    
    new_hex = 0
    
    For i = 0 To Len(nate) - 1
    
        
        'Peel off first letter
        temp = AscB(Right(Left(nate, 1 + i), 1))
        
        'Convert it to a number
        If temp >= AscB("A") And temp <= AscB("F") Then
            temp = temp - AscB("A") + 10
        ElseIf temp >= AscB("0") And temp <= AscB("9") Then
            temp = temp - AscB("0")
        End If
        
        'Shift the number
        new_hex = new_hex * 16 + temp
    
    Next
    
    Hex_Convert = new_hex

End Function

Private Sub DataPort_Click(Index As Integer)
    DataPort(1).Checked = False
    DataPort(2).Checked = False
    DataPort(3).Checked = False
    DataPort(4).Checked = False
    DataPort(5).Checked = False
    DataPort(6).Checked = False
    DataPort(Index).Checked = True
    
    CommPort = Right(DataPort(Index).Caption, 1)
End Sub

Private Sub DataSpeed_Click(Index As Integer)
    DataSpeed(1).Checked = False
    DataSpeed(2).Checked = False
    DataSpeed(3).Checked = False
    DataSpeed(4).Checked = False
    DataSpeed(5).Checked = False
    DataSpeed(Index).Checked = True
    
    CommSpeed = DataSpeed(Index).Caption
End Sub

Private Sub File_Close_Click()
    
    'Exit the program
    End

End Sub



Private Sub File_Open_Click()
    Call cmdBrowse_Click
End Sub

Private Sub Form_Load()
    
On Error GoTo errorhandler

    lblDownloadBarFG.Width = 0
    timeoutFlag = False
    
    'Read in the settings file - if available
    Open App.Path & "\settings.txt" For Input As #1
        Input #1, CommPort, CommSpeed, PICSpeed, Chip_Type, txtUserFile
    Close #1
    
    txtFileName.Text = txtUserFile
    
    DataPort(CommPort).Checked = True
    
    If CommSpeed = 9600 Then DataSpeed(1).Checked = True
    If CommSpeed = 19200 Then DataSpeed(2).Checked = True
    If CommSpeed = 38400 Then DataSpeed(3).Checked = True
    If CommSpeed = 57600 Then DataSpeed(4).Checked = True
    If CommSpeed = 115200 Then DataSpeed(5).Checked = True
    
    If PICSpeed = 20 Then Osc(1).Checked = True
    If PICSpeed = 8 Then Osc(2).Checked = True
    If PICSpeed = 4 Then Osc(3).Checked = True
    
    If Chip_Type = "16F877A" Then ChipType(1).Checked = True
    If Chip_Type = "16F876A" Then ChipType(2).Checked = True
    If Chip_Type = "16F873A" Then ChipType(3).Checked = True
    If Chip_Type = "16F88" Then ChipType(4).Checked = True
    
    Exit Sub

errorhandler:
    
    If Err.Number = 53 Then 'No File found
        'Default values
        CommPort = 1
        DataPort(1).Checked = True
        
        CommSpeed = 9600
        DataSpeed(1).Checked = True
        
        PICSpeed = 20
        Osc(1).Checked = True
        
        ChipType(1).Checked = True
        Chip_Type = "16F877A"
    ElseIf Err.Number = 62 Then
        'Problem with the file, close it and default options
        Close #1
        
        'Default values
        CommPort = 1
        DataPort(1).Checked = True
        
        CommSpeed = 9600
        DataSpeed(1).Checked = True
        
        PICSpeed = 20
        Osc(1).Checked = True
        
        ChipType(1).Checked = True
        Chip_Type = "16F877A"
        
    Else
        MsgBox Err.Number & " = " & Err.Description
    End If
    
End Sub

Private Sub Form_Terminate()
    
On Error GoTo errorhandler
    
    Open App.Path & "\settings.txt" For Output As #1
        Write #1, CommPort, CommSpeed, PICSpeed, Chip_Type, txtUserFile
    Close #1
    
    Exit Sub

errorhandler:
    MsgBox Err.Number & " = " & Err.Description

End Sub

Private Sub Settings_Click()
    UserSettings.Show
End Sub

Private Sub Osc_Click(Index As Integer)
    Osc(1).Checked = False
    Osc(2).Checked = False
    Osc(3).Checked = False
    Osc(Index).Checked = True
    
    If Index = 1 Then PICSpeed = 20
    If Index = 2 Then PICSpeed = 8
    If Index = 3 Then PICSpeed = 4
End Sub
