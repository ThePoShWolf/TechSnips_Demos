#region Create Certificate
# Create certificate
$newCertSplat = @{
    DnsName = '<dnsname>'
    CertStoreLocation = 'cert:\CurrentUser\My'
    NotAfter = (Get-Date).AddYears(1)
    KeySpec = 'KeyExchange'
}
$mycert = New-SelfSignedCertificate @newCertSplat

# Export certificate to .pfx file
$exportCertSplat = @{
    FilePath = 'ExoCert.pfx'
    Password = $(ConvertTo-SecureString -String "P@ssw0Rd1234" -AsPlainText -Force)
}
$mycert | Export-PfxCertificate @exportCertSplat

# Export certificate to .cer file
$mycert | Export-Certificate -FilePath ExoCert.cer

#endregion

#region Use Certificate
$connectSplat = @{
    CertificateFilePath = 'C:\path\ExoCert.pfx'
    CertificatePassword = $(ConvertTo-SecureString -String "P@ssw0Rd1234" -AsPlainText -Force)
    AppId = '<appId>'
    Organization = "<org>"
}
Connect-ExchangeOnline @connectSplat

# Test
Get-EXOMailbox <email> | ft DisplayName


#endregion