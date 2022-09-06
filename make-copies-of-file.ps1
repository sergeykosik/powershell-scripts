$source="C:\temp\inv-001.pdf";
$target="C:\temp\300 files";
$maxNum = 302;
for($i=1; $i -lt $maxNum; $i++)
{
  Copy-Item "$($source)" "$($target)\inv-$($i).pdf";
}