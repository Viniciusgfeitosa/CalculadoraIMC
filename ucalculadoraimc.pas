unit uCalculadoraIMC;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCalcular: TButton;
    btnLimpar: TButton;
    edtAltura: TEdit;
    edtPeso: TEdit;
    lblAltura: TLabel;
    lblPeso: TLabel;
    lblIMC: TLabel;
    lblClassificacao: TLabel;
    procedure btnCalcularClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
  private
    function ParseFloatBR(const S: string): Double;
    function ClassificarIMC(const IMC: Double): string;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

// Funções

function TForm1.ParseFloatBR(const S: string): Double;
var
  fs: TFormatSettings;
  tmp: string;
begin
  tmp := Trim(S);
  fs := DefaultFormatSettings;

  // tenta com vírgula
  fs.DecimalSeparator := ',';
  if TryStrToFloat(tmp, Result, fs) then Exit;

  // tenta com ponto
  fs.DecimalSeparator := '.';
  if TryStrToFloat(tmp, Result, fs) then Exit;

  raise Exception.Create('Número inválido. Exemplo: 70,5 ou 1,75');
end;

function TForm1.ClassificarIMC(const IMC: Double): string;
begin
  if IMC < 18.5 then
    Result := 'Abaixo do peso'
  else if IMC < 25.0 then
    Result := 'Peso normal'
  else if IMC < 30.0 then
    Result := 'Sobrepeso'
  else if IMC < 35.0 then
    Result := 'Obesidade grau I'
  else if IMC < 40.0 then
    Result := 'Obesidade grau II'
  else
    Result := 'Obesidade grau III';
end;

// Eventos

procedure TForm1.btnCalcularClick(Sender: TObject);
var
  peso, altura, imc: Double;
  classificacao: string;
begin
  try
    if Trim(edtPeso.Text) = '' then
      raise Exception.Create('Informe o peso.');
    if Trim(edtAltura.Text) = '' then
      raise Exception.Create('Informe a altura.');

    peso := ParseFloatBR(edtPeso.Text);
    altura := ParseFloatBR(edtAltura.Text);

    if peso <= 0 then
      raise Exception.Create('Peso deve ser maior que zero.');
    if altura <= 0 then
      raise Exception.Create('Altura deve ser maior que zero.');

    imc := peso / (altura * altura);
    classificacao := ClassificarIMC(imc);

    lblIMC.Caption := Format('IMC: %.2f', [imc]);
    lblClassificacao.Caption := 'Classificação: ' + classificacao;

  except
    on E: Exception do
      MessageDlg('Erro', E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TForm1.btnLimparClick(Sender: TObject);
begin
  edtPeso.Clear;
  edtAltura.Clear;
  lblIMC.Caption := 'IMC: -';
  lblClassificacao.Caption := 'Classificação: -';
  edtPeso.SetFocus;
end;

end.

