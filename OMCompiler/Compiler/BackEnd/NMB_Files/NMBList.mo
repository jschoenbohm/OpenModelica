encapsulated package NMBList
" file:        List.mo
  package:     List
  description: 
  
  List functions

  This package contains all functions that operate on the List type, such as
  mapping and filtering functions.
"
import MetaModelica.Dangerous.{listReverseInPlace, arrayGetNoBoundsChecking, arrayUpdateNoBoundsChecking, arrayCreateNoInit};
/* 
 *
 * public functions section 
 *
 */
public 
public function consOption<T>
  "Adds an optional element to the front of the list, or returns the list if the
   element is none."
  input Option<T> inElement;
  input list<T> inList;
  output list<T> outList;
algorithm
  outList := match(inElement)
    local
      T e;

    case SOME(e) then e :: inList;
    else inList;
  end match;
end consOption;

function fold<T, FT>
  "Takes a list and a function operating on list elements having an extra
   argument that is 'updated', thus returned from the function. fold will call
   the function for each element in a sequence, updating the start value.
     Example: fold({1, 2, 3}, intAdd, 2) => 8
              intAdd(1, 2) => 3, intAdd(2, 3) => 5, intAdd(3, 5) => 8"
  input list<T> inList;
  input FoldFunc inFoldFunc;
  input FT inStartValue;
  output FT outResult = inStartValue;

  partial function FoldFunc
    input T inElement;
    input FT inFoldArg;
    output FT outFoldArg;
  end FoldFunc;
algorithm
  for e in inList loop
    outResult := inFoldFunc(e, outResult);
  end for;
end fold;

public function unzipFirst<T1, T2>
  "Takes a list of two-element tuples and creates a list from the first element
   of each tuple. Example: unzipFirst({(1, 2), (3, 4)}) => {1, 3}"
  input list<tuple<T1, T2>> inTuples;
  output list<T1> outList = {};
protected
  T1 e;
algorithm
  for tpl in inTuples loop
    (e, _) := tpl;
    outList := e :: outList;
  end for;
  outList := listReverseInPlace(outList);
end unzipFirst;


function getMemberOnTrue<T, VT>
  "Takes a value and a list of values and a comparison function over two values.
   If the value is present in the list (using the comparison function returning
   true) the value is returned, otherwise the function fails.
   Example:
     function equalLength(string,string) returns true if the strings are of same length
     getMemberOnTrue(\"a\",{\"bb\",\"b\",\"ccc\"},equalLength) => \"b\""
  input VT inValue;
  input list<T> inList;
  input CompFunc inCompFunc;
  output T outElement;

  partial function CompFunc
    input VT inValue;
    input T inElement;
    output Boolean outIsEqual;
  end CompFunc;
algorithm
  for e in inList loop
    if inCompFunc(inValue, e) then
      outElement := e;
      return;
    end if;
  end for;
  fail();
end getMemberOnTrue;

public function isMemberOnTrue<T, VT>
  "Returns true if the given value is a member of the list, as determined by the
  comparison function given."
  input VT inValue;
  input list<T> inList;
  input CompFunc inCompFunc;
  output Boolean outIsMember;

  partial function CompFunc
    input VT inValue;
    input T inElement;
    output Boolean outIsEqual;
  end CompFunc;
algorithm
  for e in inList loop
    if inCompFunc(inValue, e) then
      outIsMember := true;
      return;
    end if;
  end for;

  outIsMember := false;
end isMemberOnTrue;

function map<TI, TO>
  "Takes a list and a function, and creates a new list by applying the function
   to each element of the list."
  input list<TI> inList;
  input MapFunc inFunc;
  output list<TO> outList;

  partial function MapFunc
    input TI inElement;
    output TO outElement;
  end MapFunc;
algorithm
  outList := list(inFunc(e) for e in inList);
end map;

public function map1<TI, TO, ArgT1>
  "Takes a list, a function and one extra argument, and creates a new list
   by applying the function to each element of the list."
  input list<TI> inList;
  input MapFunc inMapFunc;
  input ArgT1 inArg1;
  output list<TO> outList;

  partial function MapFunc
    input TI inElement;
    input ArgT1 inArg1;
    output TO outElement;
  end MapFunc;
algorithm
  outList := list(inMapFunc(e, inArg1) for e in inList);
end map1;

function mapList<TI, TO>
  "Takes a list of lists and a functions, and creates a new list of lists by
   applying the function to all elements in  the list of lists.
     Example: mapList({{1, 2},{3},{4}}, intString) =>
                      {{\"1\", \"2\"}, {\"3\"}, {\"4\"}}"
  input list<list<TI>> inListList;
  input MapFunc inFunc;
  output list<list<TO>> outListList;

  partial function MapFunc
    input TI inElement;
    output TO outElement;
  end MapFunc;
algorithm
  outListList := list(list(inFunc(e) for e in lst) for lst in inListList);
end mapList;

public function dump<T>
  "Takes a list and a function, and creates a new list as a String ...,...,... (without leading and trailing {} ) by applying the function to each element of the list."
  input list<T> inList;
  input MapFunc inFunc;
  output String s;

  partial function MapFunc
    input T inElement;
    output String s;
  end MapFunc;
  protected
    list<T> tail;
    T head;
algorithm
  s := match(inList)
  case {} 
		then "";
  case head::{}
    then inFunc(head);
  case head::tail
    then inFunc(head) + "," + dump(tail, inFunc);
  end match;  
end dump;

/* 
 *
 * protected functions section 
 *
 */

annotation(__OpenModelica_Interface="backend");
end NMBList;