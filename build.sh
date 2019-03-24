## Script to build the modified version of mSWEEP for use within the shiny app
git clone https://github.com/PROBIC/mSWEEP.git
cp read_bitfield.cpp mSWEEP/src/
mkdir mSWEEP/build
cd mSWEEP/build
cmake ..
make
cd ../../
mv mSWEEP/mSWEEP ./
rm -rf mSWEEP
