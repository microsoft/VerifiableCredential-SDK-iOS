/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public protocol BackupProtectionMethod {
    func wrap(unprotectedBackupData: UnprotectedBackupData) throws -> ProtectedBackupData
    func unwrap(protectedBackupData: ProtectedBackupData) throws -> UnprotectedBackupData
}
