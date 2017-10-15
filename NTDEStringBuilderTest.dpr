program NTDEStringBuilderTest;

{$APPTYPE CONSOLE}
{$ZEROBASEDSTRINGS ON}
{$R *.res}

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  NTDEStringBuilder in 'NTDEStringBuilder.pas';


function Randomstring(ALen: Integer): string;
var
  i: Integer;
const
  str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
begin
  Result := '';
  for i := 1 to ALen do
    Result := Result + str[Random(str.Length)];
end;

const
  TestCount = 10000;
  TestStringCount = 1000;
  TestNumberCount = 1000;
  TestCharCount   = 10000;

var
  i, j: Integer;
  C: Char;
  LString: string;
  LStrings: TList<string>;
  LNumber: Integer;
  LNumbers: TList<Integer>;
  LTick: Cardinal;
  LStringBuilder: TStringBuilder;
  LNTDEStringBuilder: TNTDEStringBuilder;

begin
  Randomize;
  LStringBuilder := TStringBuilder.Create;
  LNTDEStringBuilder := TNTDEStringBuilder.Create;
  // Generate random strings
  LStrings := TList<string>.Create;
  for i := 1 to TestStringCount do
    LStrings.Add(Randomstring(Random(20) + 10));

  // Generate random numbers
  LNumbers := TList<Integer>.Create;
  for i := 1 to TestNumberCount do
    LNumbers.Add(Random(100000) - 50000);

  // Test performance of TStringBuilder
  LTick := TThread.GetTickCount;
  for i := 1 to TestCount do
  begin
    LStringBuilder.Clear;
    for LString in LStrings do
      LStringBuilder.Append(LString);
    for LNumber in LNumbers do
      LStringBuilder.Append(LNumber);
    for j := 1 to TestCharCount do
      for C := 'A' to 'Z' do
        LStringBuilder.Append(C);
  end;
  Writeln('TStringBuilder: ', TThread.GetTickCount - LTick, 'ms');

  // Test performance of TNTDEStringBuilder
  LTick := TThread.GetTickCount;
  for i := 1 to TestCount do
  begin
    LNTDEStringBuilder.Clear;
    for LString in LStrings do
      LNTDEStringBuilder.Append(LString);
    for LNumber in LNumbers do
      LNTDEStringBuilder.Append(LNumber);
    for j := 1 to TestCharCount do
      for C := 'A' to 'Z' do
        LNTDEStringBuilder.Append(C);
  end;
  Writeln('TNTDEStringBuilder: ', TThread.GetTickCount - LTick, 'ms');

  LStrings.Clear;
  LStrings.Free;
  //
  LNumbers.Clear;
  LNumbers.Free;
  //
  LStringBuilder.Free;
  LNTDEStringBuilder.Free;

  Writeln('Done..Press <ENTER> to exit...');
  Readln;
end.
