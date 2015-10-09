$strComputer = "."
$objWMIService = GetObject("winmgmts:\\"+ $strComputer + "\root\cimv2")
$colItems = $objWMIService.ExecQuery("Select * from Win32_Keyboard")
For Each $objItem in $colItems
    ? "Availability:" + $objItem.Availability
        ? "Caption:" + $objItem.Caption
            ? "Config Manager Error Code:" + $objItem.ConfigManagerErrorCode
                ? "Config Manager User Config:" + $objItem.ConfigManagerUserConfig
                    ? "Creation Class Name:" + $objItem.CreationClassName
                        ? "Description:" + $objItem.Description
                            ? "Device ID:" + $objItem.DeviceID
                                ? "Error Cleared:" + $objItem.ErrorCleared
                                    ? "Error Description:" + $objItem.ErrorDescription
                                        ? "Install Date:" + $objItem.InstallDate
                                            ? "Is Locked:" + $objItem.IsLocked
                                                ? "Last Error Code:" + $objItem.LastErrorCode
                                                    ? "Layout:" + $objItem.Layout
                                                        ? "Name:" + $objItem.Name
                                                            ? "Number Of Function Keys:" + $objItem.NumberOfFunctionKeys
                                                                ? "Password:" + $objItem.Password
                                                                    ? "PNP Device ID:" + $objItem.PNPDeviceID
                                                                        For Each $x in $objItem.PowerManagementCapabilities
                                                                                ? "Power Management Capabilities:" + $x
                                                                                    Next
                                                                                        ? "Power Management Supported:" + $objItem.PowerManagementSupported
                                                                                            ? "Status:" + $objItem.Status
                                                                                                ? "Status Info:" + $objItem.StatusInfo
                                                                                                    ? "System Creation Class Name:" + $objItem.SystemCreationClassName
                                                                                                        ? "System Name:" + $objItem.SystemName
                                                                                                        Next 
