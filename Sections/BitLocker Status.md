<div align="center">

# 🔐 BitLocker Encryption Status

## **Information Pulled:**  
MountPoint – The drive letter or mount point for each volume  
VolumeType – The type of volume (e.g., Fixed, Removable)  
ProtectionStatus – Indicates if BitLocker protection is on, off, or suspended  
EncryptionMethod – The algorithm/method used for encryption  
EncryptionPercentage – How much of the volume is currently encrypted  
KeyProtector – The types of BitLocker key protectors present (e.g., password, TPM, recovery key)  
Section – Static identifier labeling the data as `"BitLockerStatus"`

---

## **Purpose & Usefulness:**  
This function collects the encryption status for all detected disk volumes using BitLocker.

Details such as ProtectionStatus, EncryptionMethod, and EncryptionPercentage are vital for determining if data on the system is protected at rest.  
KeyProtector types indicate how encryption keys are managed, which impacts recoverability and attack surface.  
This information is critical for compliance validation, digital forensics, and incident response,  
providing insight into whether sensitive data may be protected or exposed if drives are removed or stolen.

</div>
