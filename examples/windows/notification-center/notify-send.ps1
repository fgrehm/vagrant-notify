
# Example Windows 10 Notification Center notify-send wrapper PowerShell script. (I apologize if you find this script a bit messy, PowerShell is not my forte)

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] > $null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null

$arguments = @{};
$non_opt   = @();
$title     = "";
$message   = "";
$icon      = "";
$help = "Usage:
  notify-send [Options][body]
    -i, --icon ICON
    --help
  ";


for ( $i = 0; $i -lt $args.count; $i++ ) {
  switch -regex ($args[ $i ]) {
  "^\-u="               { $arguments.Add("-u", $args[ $i ]); }          # Option gets ignored
  "^\-u$"               { $arguments.Add("-u", $args[ $i+1 ]); $i+=1; } # Option gets ignored
  "^\-\-urgency="       { $arguments.Add("-u", $args[ $i ]); }          # Option gets ignored
  "^\-\-urgency$"       { $arguments.Add("-u", $args[ $i+1 ]); $i+=1; } # Option gets ignored
  "^\-t="               { $arguments.Add("-t", $args[ $i ]); }          # Option gets ignored
  "^\-t$"               { $arguments.Add("-t", $args[ $i+1 ]); $i+=1; } # Option gets ignored
  "^\-\-expire\-time="  { $arguments.Add("-t", $args[ $i ]); }          # Option gets ignored
  "^\-\-expire\-time$"  { $arguments.Add("-t", $args[ $i+1 ]); $i+=1; } # Option gets ignored
  "^\-a="               { $arguments.Add("-a", $args[ $i ]); }          # Option gets ignored
  "^\-a$"               { $arguments.Add("-a", $args[ $i+1 ]); $i+=1; } # Option gets ignored
  "^\-\-app\-name="     { $arguments.Add("-a", $args[ $i ]); }          # Option gets ignored
  "^\-\-app\-name$"     { $arguments.Add("-a", $args[ $i+1 ]); $i+=1; } # Option gets ignored
  "^\-i=(.*)"           { $args[ $i ] -match '=(.*)'; $arguments.Add("-i", $matches[1]); }
  "^\-i$"               { $arguments.Add("-i", $args[ $i+1 ]); $i+=1; }
  "^\-\-icon="          { $args[ $i ] -match '=(.*)'; $arguments.Add("-i", $matches[1]); }
  "^\-\-icon$"          { $arguments.Add("-i", $args[ $i +1]); $i+=1; }
  "^\-h="               { $arguments.Add("-h", $args[ $i ]); }          # Option gets ignored
  "^\-h$"               { $arguments.Add("-h", $args[ $i+1 ]); $i+=1; } # Option gets ignored
  "^\-\-hint="          { $arguments.Add("-h", $args[ $i ]); }          # Option gets ignored
  "^\-\-hint$"          { $arguments.Add("-h", $args[ $i+1 ]); $i+=1; } # Option gets ignored
  "^\-v$"               { $arguments.Add("-v", "vagrant-notify"); }     # Option gets ignored
  "^\-\-version$"       { $arguments.Add("-v", "vagrant-notify"); }     # Option gets ignored
  "^\-\-help$"          { $arguments.Add("--help", $help); }
  default               { $non_opt += $args[ $i ]; }
  }
}

#Write-Host "Num Args:" $args.Length;
#Write-Host "CLI is: " $arguments.Count;
#Write-Host "MSG is: " $non_opt.Count;

If ($arguments.Get_Item("--help")) {
  Write-Host $help
  exit 1;
}
If ($arguments.Get_Item("-i")) {
  $icon = $arguments."-i";
}


If ($args.Length -eq 0 ) {
  Write-Host "No Summary Specified";
  exit 1;
  
} ElseIf ($non_opt.Count -eq 1) {
  $message = $non_opt[0];

  If($arguments.Get_Item("-i")) { $icon = $arguments."-i"; }
  
} ElseIf ($non_opt.Count -eq 2) {
  $title = $non_opt[0];
  $message = $non_opt[1];

  If($arguments.Get_Item("-i")) { $icon = $arguments."-i"; }
  
} ElseIf ($non_opt.Length -gt 2) {
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
