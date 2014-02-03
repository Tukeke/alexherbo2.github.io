<!-- wiki
     ==== -->

Browsing
--------

To browse, select and paste in your terminal.

```sh
cd /tmp
mkdir alexherbo2
cd alexherbo2
git clone https://github.com/alexherbo2/wiki
cd wiki
git pull
eval $EXPLORER wiki
```

It tries to start `EXPLORER` (this is a non-standard variable).

Selected files will be opened with your editor.
