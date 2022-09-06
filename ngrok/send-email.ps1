$email = "from@example.com" 
$pass = "xxx"  
$smtpServer = "smtp.gmail.com" 

$to = "recepient@example.com"
 
$msg = new-object Net.Mail.MailMessage 
$smtp = new-object Net.Mail.SmtpClient($smtpServer) 
$smtp.EnableSsl = $true 
$msg.From = "$email"  
$msg.To.Add("$to") 
$msg.BodyEncoding = [system.Text.Encoding]::Unicode 
$msg.SubjectEncoding = [system.Text.Encoding]::Unicode 
$msg.IsBodyHTML = $true  
$msg.Subject = "Test mail from PS" 
$msg.Body = "<h2> Test mail from PS </h2> 
</br> 
Hi there 
"  
$SMTP.Credentials = New-Object System.Net.NetworkCredential("$email", "$pass"); 
$smtp.Send($msg)
