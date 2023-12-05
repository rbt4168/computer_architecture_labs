rm -f ./*.v > /dev/null 2> /dev/null
rm -f ./*.txt > /dev/null 2> /dev/null
rm -f ./*.vcd > /dev/null 2> /dev/null
rm -f cpu

cp ../code/**/*.v ./
iverilog -o cpu ./*.v
error=$?
if [ $error -eq 0 ]; then
   echo "build pass."
elif [ $error -eq 1 ]; then
   echo "build failed."
   exit 1
else
   echo "error"
   exit 1
fi

cp ./testcases/instruction_1.txt instruction.txt
vvp cpu >/dev/null
diff ./testcases/output_1.txt output.txt >/dev/null
error=$?
if [ $error -eq 0 ]; then
   echo "test1 pass."
elif [ $error -eq 1 ]; then
   diff output.txt ./testcases/output_1.txt
   echo "test1 failed."
   exit 1
else
   echo "error"
   exit 1
fi

cp ./testcases/instruction_2.txt instruction.txt
vvp cpu >/dev/null
diff ./testcases/output_2.txt output.txt >/dev/null
error=$?
if [ $error -eq 0 ]; then
   echo "test2 pass."
elif [ $error -eq 1 ]; then
   diff ./testcases/output_2.txt output.txt
   echo "test2 failed."
   exit 1
else
   echo "error"
   exit 1
fi

rm -f ./*.v
rm -f cpu
rm instruction.txt
rm output.txt
rm waveform.vcd