# ruby -w xls2cpp.rb sample.xls > sample.cpp
# cl /EHsc /Ox sample.cpp
# jun hirabayashi jun@hirax.net
# 2012.06.23


require 'win32ole'

def getAbsolutePath(filename)
  fso=WIN32OLE.new('Scripting.FileSystemObject')
  fso.GetAbsolutePathName(filename)
end

def getAlphabet(n)
  val=n.to_f/25.0 
  mod=n%25
  result=''
  result+=('A'..'Z').to_a[(n-val)/25] if val>1
  result+=('A'..'Z').to_a[mod]
end

def defFunc(state,book)
  src=''
  book.Worksheets.each do |sheet|
    y=1
    sheet.UsedRange.Rows.each do |row|
      x=0
      record=[]
      row.Columns.each do |cell|
        if state==:def && cell.Value.to_s!=''
          record<<'  float '+getAlphabet(x)+y.to_s+'=0.;'
        end
        if state==:init && cell.Value!=''
          record<<'  '+getAlphabet(x)+y.to_s+
            '='+cell.Value.to_s+';' if cell.Value.to_s!=''
        end
        if state==:calc && cell.Formula!=''
          t=cell.Formula.sub(/[=$]/,'')
          record<<'  '+getAlphabet(x)+y.to_s+'='+t+';' unless /^[+-]?[0-9]*[\.]?[0-9]+$/ =~ t
        end
        if state==:display && cell.Formula!=''
          record << '    cout << '+'"'+getAlphabet(x) + y.to_s+' = " << '+ getAlphabet(x) + y.to_s+' << endl;'
        end
        x+=1
      end
      if record.join('').gsub("\n",'')!=''
        src+=record.join("\n")+"\n" 
      end
      y+=1
    end
  end
  return src
end

filename=getAbsolutePath(ARGV[0])
excel=WIN32OLE.new('Excel.Application')
book=excel.Workbooks.Open(filename)
defsrc=defFunc(:def,book)
initsrc=defFunc(:init,book)
calcsrc=defFunc(:calc,book)
displaycsrc=defFunc(:display,book)
book.close
excel.quit
GC.start

puts <<INIT
// jun hirabayashi jun@hirax.net
// http://www.hirax.net

#include <iostream>
using namespace std;

// gloval variables
#{defsrc}

void init(void){
#{initsrc}}

void calc(void){
#{calcsrc}}

void display(void){
#{displaycsrc}}

int main(){
  // Initialize
  init();
  // Calculate
  for(int i = 0; i < 100; ++i){ calc(); }
  // display
  display();  
  return 0;
}
INIT
