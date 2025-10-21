```bash
checkmodule -M -m -o kanidm_policy.mod kanidm_policy.te
semodule_package -o kanidm_policy.pp -m kanidm_policy.mod
sudo semodule -i kanidm_policy.pp
```