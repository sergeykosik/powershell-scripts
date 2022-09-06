# https://theitbros.com/powershell-gui-for-scripts/ 
# https://redmondmag.com/articles/2017/01/27/convert-a-powershell-script-into-an-exe-file.aspx 

Add-Type -assembly System.Windows.Forms;
$main_form = New-Object System.Windows.Forms.Form;

$main_form.Text ='GUI for my PoSh script'
$main_form.Width = 600;
$main_form.Height = 400;
$main_form.AutoSize = $true;

$Label = New-Object System.Windows.Forms.Label;
$Label.Text = "Some Label";
$Label.Location  = New-Object System.Drawing.Point(0,10);
$Label.AutoSize = $true;
$main_form.Controls.Add($Label);

$TextBox = New-Object System.Windows.Forms.TextBox;
$TextBox.Width = 300
$TextBox.Location  = New-Object System.Drawing.Point(60,10);
$main_form.Controls.Add($TextBox);

$Button = New-Object System.Windows.Forms.Button;
$Button.Location = New-Object System.Drawing.Size(400,10);
$Button.Size = New-Object System.Drawing.Size(120,23);
$Button.Text = "Check";
$main_form.Controls.Add($Button);


$main_form.ShowDialog();