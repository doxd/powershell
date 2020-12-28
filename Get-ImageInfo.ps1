Function Get-Image ($path)
{
    begin{        
         [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") |Out-Null 
    } 
     process{
          $fi=[System.IO.FileInfo]$path           
          if( $fi.Exists){
               $img = [System.Drawing.Image]::FromFile($path)
               return $img
          }else{
               Write-Host "File not found: $_" -fore yellow       
          }   
     }    
    end{}
}


$DPI = 300
Get-ChildItem * -Include *.jpg,*.png -Recurse | % {
    $image =  Get-Image $_    
    New-Object PSObject -Property  @{ 
        File = $_.name
        Fullname = $_.Fullname
        HeightPx = $image.Height
        WidthPx = $image.Width
        DPI = $DPI
        WidthInches = $image.Width/$DPI
        HeightInches = $image.Height/$DPI

    };
} | Select-Object -Property Fullname,WidthPX, HeightPX, DPI, WidthInches, HeightInches | Format-Table

