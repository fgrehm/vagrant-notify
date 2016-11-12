
# Example Windows 10 Notification Center notify-send wrapper PowerShell script. (I apologize if you find this script a bit messy, PowerShell is not my forte)

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] > $null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null

$arguments = @{};
$clear     = @();
$title     = "";
$message   = "";
$icon      = "";
$help = "Usage:
  notify-send [Options][body]
    -i, --icon ICON
    --help
	";


for ( $i = 0; $i -lt $args.count; $i++ ) {
  #if (($args[ $i ] -eq "-u") -or ($args[ $i ] -match "--urgency"))       { $arguments.Add("-u", $args[ $i+1 ])} # Option gets ignored
	#if (($args[ $i ] -eq "-t") -or ($args[ $i ] -match "--exprire-time"))  { $arguments.Add("-t", $args[ $i+1 ])} # Option gets ignored
	#if (($args[ $i ] -eq "-a") -or ($args[ $i ] -match "--app-name"))      { $arguments.Add("-a", $args[ $i+1 ])} # Option gets ignored
	if (($args[ $i ] -eq "-i") -or ($args[ $i ] -match "--icon"))          { $arguments.Add("-i", $args[ $i+1 ]); $clear += $args[ $i ]; $clear += $args[ $i+1 ];  }  # Set to image
  #if (($args[ $i ] -eq "-c") -or ($args[ $i ] -match "--category"))      { $arguments.Add("-c", $args[ $i+1 ])} # Option gets ignored
  #if (($args[ $i ] -eq "-h") -or ($args[ $i ] -match "--hint"))          { $arguments.Add("-h", $args[ $i+1 ])} # Option gets ignored
	#if (($args[ $i ] -eq "-v") -or ($args[ $i ] -match "--version"))       { $arguments.Add("-v", $args[ $i+1 ])} # Option gets ignored
	#if ($args[ $i ] -match "--help")                                       { $arguments.Add("--help", "--help")}
}

# Get arguments not part of -i or --icon
$non_opt = Compare-Object -ReferenceObject $args -DifferenceObject $clear -PassThru

#Write-Host "Num Args:" $args.Length;
#Write-Host "CLI is: " $arguments.Count;
#Write-Host "MSG is: " $non_opt.Count;

If ($arguments.Get_Item("--help")) {
  Write-Host $help
  exit 1;
}
If ($arguments.Get_Item("-i")) {
  Write-Host "Icon!";
  $icon = $arguments."-i";
}


If ($args.Length -eq 0 ) {
  Write-Host "No Summary Specified";
  exit 1;
  
} ElseIf ( ($non_opt.Count -eq 1) -and ($arguments.Count -match '(0|1)') ) {
  $message = $non_opt;
  If($arguments.Get_Item("-i")) { $icon = $arguments."-i"; }
  
} ElseIf ( ($non_opt.Count -eq 2) -and ($arguments.Count -match '(0|1)') ) {
  $title = $non_opt[0];
  $message = $non_opt[1];
  If($arguments.Get_Item("-i")) { $icon = $arguments."-i"; }
  
} ElseIf ( ($args.Length -gt 2) -and ($arguments.Count -eq 0) ) {
  Write-Host "Invalid number of options";
  exit 1;

} Else {
  Write-Host $help
  exit 1;
}


$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$template = "<toast><visual><binding template=`"ToastImageAndText02`"><image id=`"1`" src=`"$icon`" alt=`"image`"/><text id=`"1`">$title</text><text id=`"2`">$message</text></binding></visual></toast>"

$xml.LoadXml($template)
$toast = New-Object Windows.UI.Notifications.ToastNotification $xml

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("(notify-send)").Show($toast)
