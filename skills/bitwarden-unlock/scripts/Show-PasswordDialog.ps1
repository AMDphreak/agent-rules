#Requires -Version 7
<#
.SYNOPSIS
  Native Windows password dialog (masked input).

.DESCRIPTION
  OpenShellOrg-style GUI prompt with PasswordChar masking. Use for bw unlock
  when a non-interactive terminal needs a modal master-password prompt.

  Never Write-Output the password; return via SecureString only when dot-sourced.
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $Message,

    [Parameter()]
    [string] $Title = 'Bitwarden unlock'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = $Title
$form.Size = New-Object System.Drawing.Size(420, 140)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.Topmost = $true
$form.MaximizeBox = $false
$form.MinimizeBox = $false

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(12, 12)
$label.Size = New-Object System.Drawing.Size(380, 36)
$label.Text = $Message
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(12, 52)
$textBox.Size = New-Object System.Drawing.Size(380, 24)
$textBox.UseSystemPasswordChar = $true
$form.Controls.Add($textBox)

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(230, 82)
$okButton.Size = New-Object System.Drawing.Size(75, 28)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(317, 82)
$cancelButton.Size = New-Object System.Drawing.Size(75, 28)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$result = $form.ShowDialog()
if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
    if ($MyInvocation.InvocationName -ne '.') { exit 1 }
    return $null
}

$secure = ConvertTo-SecureString -String $textBox.Text -AsPlainText -Force
$textBox.Clear()
[GC]::Collect()

if ($MyInvocation.InvocationName -ne '.') {
    # Standalone: emit BSTR once for piping into unlock script; avoid plain Write-Output.
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try {
        [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) | Write-Output
    } finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
    exit 0
}

return $secure
