@echo off

if ["%~1"]==["json"] (
    copy /-y resources\Homestead.json Homestead.json
)
if ["%~1"]==[""] (
    copy /-y resources\Homestead.yaml Homestead.yaml
)

copy /-y resources\after.sh after.sh
copy /-y resources\aliases aliases
copy /-y resources\provision-always.sh provision-always.sh

echo Homestead initialized!
