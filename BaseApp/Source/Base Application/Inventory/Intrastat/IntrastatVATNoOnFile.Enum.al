﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Inventory.Intrastat;

enum 266 "Intrastat VAT No. On File"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; "VAT Reg. No.") { Caption = 'VAT Reg. No.'; }
    value(1; "EU Country Code + VAT Reg. No") { Caption = 'EU Country Code + VAT Reg. No'; }
    value(2; "VAT Reg. No. Without EU Country Code") { Caption = 'VAT Reg. No. Without EU Country Code'; }
}
