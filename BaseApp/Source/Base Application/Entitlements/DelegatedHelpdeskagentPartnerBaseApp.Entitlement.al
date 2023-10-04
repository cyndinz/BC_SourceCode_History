namespace System.Security.AccessControl;

entitlement "Delegated Helpdesk agent - Partner BaseApp"
{
    Type = Role;
    RoleType = Delegated;
    Id = '00000000-0000-0000-0000-000000000008';
    ObjectEntitlements = "BaseApp Objects - Exec",
                         "D365 BASIC",
                         "D365 DIM CORRECTION",
                         "D365 FULL ACCESS",
                         "D365 MONITOR FIELDS",
                         "D365 RAPIDSTART",
                         "LOCAL",
                         "Security - Baseapp";
}
