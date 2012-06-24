// jun hirabayashi jun@hirax.net
// http://www.hirax.net

#include <iostream>
using namespace std;

// gloval variables
  float A1=0.;
  float B1=0.;
  float C1=0.;
  float D1=0.;
  float E1=0.;
  float A2=0.;
  float B2=0.;
  float C2=0.;
  float D2=0.;
  float E2=0.;
  float A3=0.;
  float B3=0.;
  float C3=0.;
  float D3=0.;
  float E3=0.;
  float A4=0.;
  float B4=0.;
  float C4=0.;
  float D4=0.;
  float E4=0.;
  float A5=0.;
  float B5=0.;
  float C5=0.;
  float D5=0.;
  float E5=0.;


void init(void){
  A1=0.0;
  B1=0.0;
  C1=0.0;
  D1=0.0;
  E1=0.0;
  A2=0.0;
  B2=0.0;
  C2=0.0;
  D2=0.0;
  E2=0.0;
  A3=0.0;
  B3=0.0;
  C3=3.0;
  D3=0.0;
  E3=0.0;
  A4=0.0;
  B4=0.0;
  C4=0.0;
  D4=0.0;
  E4=0.0;
  A5=0.0;
  B5=0.0;
  C5=0.0;
  D5=0.0;
  E5=0.0;
}

void calc(void){
  B2=(B1+A2+C2+B3)/4;
  C2=(C1+B2+D2+C3)/4;
  D2=(D1+C2+E2+D3)/4;
  B3=(B2+A3+C3+B4)/4;
  D3=(D2+C3+E3+D4)/4;
  B4=(B3+A4+C4+B5)/4;
  C4=(C3+B4+D4+C5)/4;
  D4=(D3+C4+E4+D5)/4;
}

void display(void){
    cout << "A1 = " << A1 << endl;
    cout << "B1 = " << B1 << endl;
    cout << "C1 = " << C1 << endl;
    cout << "D1 = " << D1 << endl;
    cout << "E1 = " << E1 << endl;
    cout << "A2 = " << A2 << endl;
    cout << "B2 = " << B2 << endl;
    cout << "C2 = " << C2 << endl;
    cout << "D2 = " << D2 << endl;
    cout << "E2 = " << E2 << endl;
    cout << "A3 = " << A3 << endl;
    cout << "B3 = " << B3 << endl;
    cout << "C3 = " << C3 << endl;
    cout << "D3 = " << D3 << endl;
    cout << "E3 = " << E3 << endl;
    cout << "A4 = " << A4 << endl;
    cout << "B4 = " << B4 << endl;
    cout << "C4 = " << C4 << endl;
    cout << "D4 = " << D4 << endl;
    cout << "E4 = " << E4 << endl;
    cout << "A5 = " << A5 << endl;
    cout << "B5 = " << B5 << endl;
    cout << "C5 = " << C5 << endl;
    cout << "D5 = " << D5 << endl;
    cout << "E5 = " << E5 << endl;
}

int main(){
  // Initialize
  init();
  // Calculate
  for(int i = 0; i < 100; ++i){ calc(); }
  // display
  display();  
  return 0;
}
