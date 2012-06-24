# ruby -w xls2cpp.rb sample.xls > sample.cpp
# cl /EHsc /Ox sample.cpp
# jun hirabayashi jun@hirax.net　2009/12/19-
# 2012.06.23rev.


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
    names={}
	book.names.each do |name|
		cell=$1.gsub('$','') if /!([^!]+)$/=~name.RefersTo
        names[cell]=name.name
	end
    src=''
    book.Worksheets.each do |sheet|
        y=1
        sheet.UsedRange.Rows.each do |row|
            x=0
            record=[]
            row.Columns.each do |cell|
                name=getAlphabet(x)+y.to_s
                name=names[name] if names[name]
                
                begin
                    rescue
                end
                if state==:def &&cell.Value.to_s!=''
                    record<<'  float '+name+'=0.;'
                end
                if state==:init &&cell.Value!=''
                    record<<'  '+name+
                    '='+cell.Value.to_s+';' if cell.Value.to_s!=''
                end
                if state==:calc &&cell.Formula!='' && !(/^[+-]?[0-9]*[\.]?[0-9]+$/ =~ cell.Formula)
                    t=cell.Formula.sub(/[=$]/,'')
                    record<<'  '+name+'='+t+';'
                end
                if state==:display && cell.Value.to_s!=''
                    t=cell.Formula.sub(/[=$]/,'')
                    record << '    cout << '+'"'+name+' = " << '+ name+' << endl;'
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
