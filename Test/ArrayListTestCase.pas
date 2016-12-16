unit ArrayListTestCase;

interface

uses
  TestFrameWork, HproseCommon;

type

  TTestCaseArrayList = class(TTestCase)
  private
    procedure CheckEqualsList(Expected: IList; Actual: IList; Msg: string = '');
  published
    procedure TestCreate;
    procedure TestAdd;
    procedure TestAddAll;
    procedure TestInsert;
    procedure TestInsertRange;
    procedure TestMove;
    procedure TestExchange;
    procedure TestContains;
    procedure TestIndexOf;
    procedure TestLastIndexOf;
    procedure TestDelete;
    procedure TestRemove;
    procedure TestClear;
    procedure TestAssign;
    procedure TestToArray;
{$IF RTLVersion >= 17.00}  // Delphi 2005 or later
    procedure TestForIn;
{$IFEND}
    procedure TestSplit;
    procedure TestJoin;
    procedure TestItem;
    procedure TestPack;
    procedure TestReverse;
  end;

implementation

uses Variants;

{ TTestCaseArrayList }

procedure TTestCaseArrayList.CheckEqualsList(Expected: IList; Actual: IList; Msg: string);
var
  I: Integer;
begin
  Check(Expected.Count = Actual.Count, Msg);
  for I := 0 to 6 do Check(Expected[I] = Actual[I], Msg);
end;

procedure TTestCaseArrayList.TestCreate;
var
  L: IArrayList;
begin
  L := ArrayList([1, 2, 3]);
  Check(L[0] = 1);
  Check(L[1] = 2);
  Check(L[2] = 3);
  L := TArrayList.Create(L);
  Check(L[0] = 1);
  Check(L[1] = 2);
  Check(L[2] = 3);
  L := TArrayList.Create(L.ToArray);
  Check(L[0] = 1);
  Check(L[1] = 2);
  Check(L[2] = 3);
  L := TArrayList.Create();
  Check(L.Count = 0);
  L := TArrayList.Create(False, True);
  L.BeginRead;
  L.EndRead;
  L.BeginWrite;
  L.EndWrite;
end;

procedure TTestCaseArrayList.TestAdd;
var
  L: IArrayList;
begin
  L := ArrayList([1, 2, 3]);
  L.Add('Hello');
  L.Add(3.14);
  L.Add(True);
  L.Add(ArrayList(['a', 'b', 'c']));
  Check(L.Count = 7);
  Check(L[3] = 'Hello');
  Check(L[4] = 3.14);
  Check(L[5] = True);
  Check(L[6].Get(0) = 'a');
  Check(L[6].Get(1) = 'b');
  Check(L[6].Get(2) = 'c');
end;

procedure TTestCaseArrayList.TestAddAll;
var
  L: Variant;
begin
  L := ArrayList([1, 2, 3]);
  Check(L.Count = 3);
  L.AddAll(ArrayList(['a', 'b', 'c']));
  Check(L.Count = 6);
  L.AddAll(L);
  Check(L.Count = 12);
  Check(L.Get(3) = 'a');
  Check(L.Get(4) = 'b');
  Check(L.Get(5) = 'c');
  Check(L.Get(6) = 1);
  Check(L.Get(7) = 2);
  Check(L.Get(8) = 3);
end;

procedure TTestCaseArrayList.TestInsert;
var
  L: Variant;
  L2: IArrayList;
  I: Integer;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  L.Insert(0, 'top');
  L.Insert(3, 'middle');
  L.Insert(6, 'bottom');
  L2 := ArrayList([1, 'abc', 3.14, True]);
  L2.Insert(0, 'top');
  L2.Insert(3, 'middle');
  L2.Insert(6, 'bottom');
  for I := 0 to 6 do Check(L.Get(I) = L2[I]);
end;

procedure TTestCaseArrayList.TestInsertRange;
var
  L: Variant;
  L2: IArrayList;
  I: Integer;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  L.InsertRange(2, ArrayList([1, 2, 3]));
  L2 := ArrayList([1, 'abc', 3.14, True]);
  L2.InsertRange(2, [1, 2, 3]);
  for I := 0 to 6 do Check(L.Get(I) = L2[I]);
end;

procedure TTestCaseArrayList.TestMove;
var
  L: Variant;
  L2: IArrayList;
  I: Integer;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  L.Move(2, 0);
  L2 := ArrayList([3.14, 1, 'abc', True]);
  for I := 0 to 6 do Check(L.Get(I) = L2[I]);
end;

procedure TTestCaseArrayList.TestExchange;
var
  L: Variant;
  L2: IArrayList;
  I: Integer;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  L.Exchange(2, 0);
  L2 := ArrayList([3.14, 'abc', 1, True]);
  for I := 0 to 6 do Check(L.Get(I) = L2[I]);
end;

procedure TTestCaseArrayList.TestContains;
var
  L: IList;
begin
  L := ArrayList([1, 'abc', 3.14, True, 'abc']);
  Check(L.Contains('hello') = False);
  Check(L.Contains('abc') = True);
end;

procedure TTestCaseArrayList.TestIndexOf;
var
  L: IList;
begin
  L := ArrayList([1, 'abc', 3.14, True, 'abc']);
  Check(L.IndexOf(3.14) = 2);
  Check(L.IndexOf(False) = -1);
end;

procedure TTestCaseArrayList.TestLastIndexOf;
var
  L: IList;
begin
  L := ArrayList([1, 'abc', 3.14, True, 'abc']);
  Check(L.LastIndexOf('abc') = 4);
  Check(L.LastIndexOf(1) = 0);
  Check(L.LastIndexOf('hello') = -1);
end;

procedure TTestCaseArrayList.TestDelete;
var
  L: IList;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  Check(L.Delete(2) = 3.14);
  Check(L.Delete(2) = True);
end;

procedure TTestCaseArrayList.TestRemove;
var
  L: IList;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  Check(L.Remove('abc') = 1);
  Check(L.Remove(True) = 2);
end;

procedure TTestCaseArrayList.TestClear;
var
  L: IList;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  L.Clear;
  Check(L.Count = 0);
end;

procedure TTestCaseArrayList.TestAssign;
var
  L: IList;
  L2: Variant;
  I: Integer;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  L2 := ArrayList([1, 2, 3]);
  Check(L2.Assign(L) = True);
  for I := 0 to 3 do Check(L[I] = L2.Get(I));
end;

procedure TTestCaseArrayList.TestToArray;
var
  L: IList;
  A: array of Integer;
  I: Integer;
begin
  L := ArrayList([1, 3, 4, 5, 9]);
  A := L.ToArray(varInteger);
  for I := 0 to Length(A) - 1 do Check(L[I] = A[I]);
end;

{$IF RTLVersion >= 17.00}  // Delphi 2005 or later
procedure TTestCaseArrayList.TestForIn;
var
  L, L2: IList;
  V: Variant;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  L2 := TArrayList.Create;
  for V in L do L2.Add(V);
  CheckEqualsList(L, L2);
end;
{$IFEND}


procedure TTestCaseArrayList.TestSplit;
var
  S: String;
begin
  S := 'Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday,';
  CheckEqualsList(
    TArrayList.Split(S),
    ArrayList(['Monday', ' Tuesday', ' Wednesday', ' Thursday', ' Friday', ' Saturday', ' Sunday', '']),
    'Split 1 failed'
  );
  CheckEqualsList(
    TArrayList.Split(S, ', '),
    ArrayList(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday,']),
    'Split 2 failed'
  );
  CheckEqualsList(
    TArrayList.Split(S, ',', 4),
    ArrayList(['Monday', ' Tuesday', ' Wednesday', ' Thursday, Friday, Saturday, Sunday,']),
    'Split 3 failed'
  );
  CheckEqualsList(
    TArrayList.Split(S, ',', 0, true),
    ArrayList(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday', '']),
    'Split 4 failed'
  );
  CheckEqualsList(
    TArrayList.Split(S, ',', 0, true, true),
    ArrayList(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']),
    'Split 5 failed'
  );
end;

procedure TTestCaseArrayList.TestJoin;
var
  S: String;
  L: IList;
begin
  S := 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
  L := TArrayList.Split(S);
  Check(L.Join('; ') = 'Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday');
  Check(L.Join('", "', '["', '"]') = '["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]');
end;

procedure TTestCaseArrayList.TestItem;
var
  L: IList;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  L[10] := 'test';
  Check(L[9] = Unassigned);
  Check(L[10] = 'test');
  L.Put(12, 'hello');
  Check(L.Get(11) = Unassigned);
  Check(L.Get(12) = 'hello');
  Check(L.Get(-1) = Unassigned);
end;

procedure TTestCaseArrayList.TestPack;
var
  L: IList;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  L[10] := 'test';
  Check(L.Count = 11);
  Check(L[10] = 'test');
  L.Pack;
  Check(L.Count = 5);
  Check(L[4] = 'test');
end;

procedure TTestCaseArrayList.TestReverse;
var
  L: IList;
begin
  L := ArrayList([1, 'abc', 3.14, True]);
  L.Reverse;
  CheckEqualsList(L, ArrayList([True, 3.14, 'abc', 1]));
end;

initialization
  TestFramework.RegisterTest(TTestCaseArrayList.Suite);

end.
