# shops-bridge

This resource provides a workaround to use society accounts in jaksam's Shops Creator resource with QBox.

## Usage

1. Copy `shops-bridge` folder into your server resources.
2. Add `ensure shops-bridge` to your server.cfg file *AFTER* your bankin script and before shops_creator.
3. Change the config in shops creator `shops_creator/integrations/sh_integrations.lua` around line 25 to use shops-bridge:

```
    -- Scripts used for societies accounts
    ["qb-management"] = "shops-bridge",
    ["qb-bossmenu"] = "qb-bossmenu",
    ["esx_addonaccount"] = "esx_addonaccount",
    ["qb-banking"] = "qb-banking",
```

Note: This is a quick and dirty workaround until shops creator officially supports QBox.

