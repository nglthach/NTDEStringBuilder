unit NTDEStringBuilder;

interface

uses
  System.Classes,
  System.SysUtils;

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
    procedure Malloc(const ASize: Integer); {$IFNDEF CPUX64} inline; {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Append(const AValue: Char); overload; {$IFNDEF CPUX64} inline; {$ENDIF}
    procedure Append(const AValue: Integer); overload; {$IFNDEF CPUX64} inline; {$ENDIF}
    procedure Append(const AValue: Cardinal); overload; {$IFNDEF CPUX64} inline; {$ENDIF}
    procedure Append(const AValue: string); overload; {$IFNDEF CPUX64} inline; {$ENDIF}
    procedure Append(const AValue: TCharArray; const ALength: Integer); overload; {$IFNDEF CPUX64} inline; {$ENDIF}
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

  FNextChar^ := AValue;
  Inc(FLength);
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

  Move(AValue[0], FNextChar^, LLen * SizeOf(Char));
  Inc(FLength, LLen);
  Inc(FNextChar, LLen);
end;

procedure TNTDEStringBuilder.Append(const AValue: TCharArray; const ALength: Integer);
begin
  if FLength + ALength >= FCapacity then
    Malloc(ALength);

  Move(AValue[0], FNextChar^, ALength * SizeOf(Char));
  Inc(FLength, ALength);
  Inc(FNextChar, ALength);
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
begin
  SetLength(FString, FLength + ASize + MALLOC_SIZE);
  FNextChar := @FString[FLength];
  FCapacity := FLength + ASize + MALLOC_SIZE;
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
