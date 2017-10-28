program NTDEStringBuilderTest;

{$APPTYPE CONSOLE}
{$ZEROBASEDSTRINGS ON}
{$DEFINE USE_FAST_STRINGBUILDER}
{$R *.res}

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
{$IFDEF USE_FAST_STRINGBUILDER}
  FastStringBuilder,
{$ENDIF}
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
  LTestString: string;
  LString: string;
  LStrings: TList<string>;
  LNumber: Integer;
  LNumbers: TList<Integer>;
  LTick: Cardinal;
  LStringBuilder: TStringBuilder;
  LNTDEStringBuilder: TNTDEStringBuilder;
{$IFDEF USE_FAST_STRINGBUILDER}
  LFastStringBuilder: FastStringBuilder.TStringBuilder;
{$ENDIF}

begin
  Randomize;
  LStringBuilder := TStringBuilder.Create;
  LNTDEStringBuilder := TNTDEStringBuilder.Create;
{$IFDEF USE_FAST_STRINGBUILDER}
  LFastStringBuilder := FastStringBuilder.TStringBuilder.Create;
{$ENDIF}
  // Generate random strings
  LStrings := TList<string>.Create;
  for i := 1 to TestStringCount do
    LStrings.Add(Randomstring(Random(20) + 10));

  // Generate random numbers
  LNumbers := TList<Integer>.Create;
  for i := 1 to TestNumberCount do
    LNumbers.Add(Random(100000) - 50000);

  // Test TNTDEStringBuilder
  for i := 1 to 1000 do
  begin
    LTestString := '';
    LNTDEStringBuilder.Reset;
    for LString in LStrings do
    begin
      LTestString := LTestString + LString;
      LNTDEStringBuilder.Append(LString);
    end;

    Assert(LTestString = LNTDEStringBuilder.ToString);
  end;

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

{$IFDEF USE_FAST_STRINGBUILDER}
  // Test performance of TStringBuilder (fastcode)
  LTick := TThread.GetTickCount;
  for i := 1 to TestCount do
  begin
    LFastStringBuilder.Clear;
    for LString in LStrings do
      LFastStringBuilder.Append(LString);
    for LNumber in LNumbers do
      LFastStringBuilder.Append(LNumber);
    for j := 1 to TestCharCount do
      for C := 'A' to 'Z' do
        LFastStringBuilder.Append(C);
  end;
  Writeln('TFastStringBuilder: ', TThread.GetTickCount - LTick, 'ms');
{$ENDIF}

  LStrings.Clear;
  LStrings.Free;
  //
  LNumbers.Clear;
  LNumbers.Free;
  //
  LStringBuilder.Free;
  LNTDEStringBuilder.Free;
{$IFDEF USE_FAST_STRINGBUILDER}
  LFastStringBuilder.Free;
{$ENDIF}

  Writeln('Done..Press <ENTER> to exit...');
  Readln;
end.
