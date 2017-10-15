unit NTDEStringBuilder;

interface

uses
  System.Classes,
  System.SysUtils,
  Winapi.Windows;

{$ZEROBASEDSTRINGS ON}

type
  TNTDEStringBuilder = class
  private
    const MALLOC_SIZE = 10 * 1024; // 10KB
  private
    FCapacity: Integer;
    FLength: Integer;
    FString: TCharArray;
    FNextChar: PChar;
    procedure Malloc(const ASize: Integer); inline;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Append(const AValue: Char); overload; inline;
    procedure Append(const AValue: Integer); overload; inline;
    procedure Append(const AValue: Cardinal); overload; inline;
    procedure Append(const AValue: string); overload; inline;
    procedure Clear;
    procedure Reset;
    function ToString: string; override;
  public
    property Length: Integer read FLength;
  end;

implementation

{ TNTDEStringBuilder }

procedure TNTDEStringBuilder.Append(const AValue: Char);
begin
  if FLength >= FCapacity then
    Malloc(1);

  FNextChar[0] := AValue;
  FLength := FLength + 1;
  Inc(FNextChar);
end;

procedure TNTDEStringBuilder.Append(const AValue: Integer);
begin
  Append(IntToStr(AValue));
end;

procedure TNTDEStringBuilder.Append(const AValue: Cardinal);
begin
  Append(UIntToStr(AValue));
end;

procedure TNTDEStringBuilder.Append(const AValue: string);
var
  LLen: Integer;
begin
  LLen := AValue.Length;
  if FLength + LLen >= FCapacity then
    Malloc(LLen);

  CopyMemory(FNextChar, @AValue[0], LLen * SizeOf(Char));
  FLength := FLength + LLen;
  Inc(FNextChar, LLen);
end;

procedure TNTDEStringBuilder.Clear;
begin
  FLength := 0;
  FNextChar := @FString[0];
end;

constructor TNTDEStringBuilder.Create;
begin
  Reset;
end;

destructor TNTDEStringBuilder.Destroy;
begin
  SetLength(FString, 0);
end;

procedure TNTDEStringBuilder.Malloc(const ASize: Integer);
var
  LOldLength: Integer;
  LOldCapacity: Integer;
begin
  LOldLength := FLength;
  LOldCapacity := FCapacity;
  try
    FCapacity := FLength + ASize + MALLOC_SIZE;
    SetLength(FString, FCapacity);
    FNextChar := @FString[FLength];
  except
    on E: EOutOfMemory do
    begin
      FLength := LOldLength;
      FCapacity := LOldCapacity;
      raise;
    end;
  end;
end;

procedure TNTDEStringBuilder.Reset;
begin
  FCapacity := MALLOC_SIZE;
  SetLength(FString, FCapacity);
  Clear;
end;

function TNTDEStringBuilder.ToString: string;
begin
  SetString(Result, PChar(@FString[0]), FLength);
end;

end.
