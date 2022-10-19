#include "rwmake.ch"
#include "protheus.ch"

#define DMPAPER_A4 9

User Function VTRL002()

    Local oReport := nil as object

    oReport := ReportDef()

    oReport:printDialog()

Return

Static Function ReportDef()

    Local oReport   := nil as object
    Local oSection1 := nil as object
    Local cTitulo   := ""  as character
    Local cPerg     := ""  as character
    Local cAlias    := ""  as character

    cPerg := "VTRL002"

    Pergunte(cPerg,.T.)

    cAlias := GetNextAlias()

    cTitulo := "[VTRL002] - Impressão de Clientes"

    oReport := TReport():New('VTRL002', cTitulo, cPerg, {|oReport| PrintReport(oReport,cAlias)},"Este relatorio ira imprimir a relacao de clientes.")
    oReport:SetPortrait()
    oReport:SetTotalInLine(.F.)
    oReport:ShowHeader()

    oSection1 := TRSection():New(oReport,"Filial",{cAlias})
    oSection1:SetTotalInLine(.F.)

    TRCell():New( oSection1, "A1_FILIAL" , cAlias, 'FILIAL'    ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "A1_LOJA" , cAlias, 'LOJA'   ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "A1_END" , cAlias, 'ENDEREÇO'    ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "A1_COD"    , cAlias, 'COD.INT'   , PesqPict('SA1',"A1_COD"), 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "A1_NREDUZ" , cAlias, 'NOME FANTASIA'   ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "A1_TIPO"   , cAlias, 'TIPO' ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "A1_EST"  , cAlias, 'ESTADO'    ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "A1_MUN"   , cAlias, 'MUNICIPIO'      ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )

    oBreak := TRBreak():New(oSection1,oSection1:Cell("A1_FILIAL"),,.F.)

    TRFunction():New(oSection1:Cell("A1_FILIAL"),"TOTAL FILIAL","COUNT",oBreak,,"@E 999999",,.F.,.F.)

    TRFunction():New(oSection1:Cell("A1_FILIAL"),"TOTAL GERAL" ,"COUNT",,,"@E 999999",,.F.,.T.)

Return oReport

Static Function PrintReport(oReport,cAlias)

    Local oSection1 := oReport:Section(1)

    oSection1:Init()
    oSection1:SetHeaderSection(.T.)

    if !fGetData(cAlias)
        FWAlertError("Sem dados a exibir.","Sem dados!")
        Return
    endif

    oReport:SetMeter((cAlias)->(RecCount()))

    While !(cAlias)->(EOF()) 

        If oReport:Cancel()
            Exit
        EndIf

        oReport:IncMeter()

        oSection1:Cell("A1_FILIAL"):SetValue((cAlias)->A1_FILIAL)
        oSection1:Cell("A1_FILIAL"):SetAlign("CENTER")

        oSection1:Cell("A1_LOJA"):SetValue((cAlias)->A1_LOJA)
        oSection1:Cell("A1_LOJA"):SetAlign("CENTER")

        oSection1:Cell("A1_END"):SetValue((cAlias)->A1_END)
        oSection1:Cell("A1_END"):SetAlign("CENTER")

        oSection1:Cell("A1_COD"):SetValue((cAlias)->A1_COD)
        oSection1:Cell("A1_COD"):SetAlign("CENTER")

        oSection1:Cell("A1_NREDUZ"):SetValue((cAlias)->A1_NREDUZ)
        oSection1:Cell("A1_NREDUZ"):SetAlign("LEFT")

        oSection1:Cell("A1_TIPO"):SetValue((cAlias)->A1_TIPO)
        oSection1:Cell("A1_TIPO"):SetAlign("LEFT")

        oSection1:Cell("A1_EST"):SetValue((cAlias)->A1_EST)
        oSection1:Cell("A1_EST"):SetAlign("LEFT")

        oSection1:Cell("A1_MUN"):SetValue((cAlias)->A1_MUN)
        oSection1:Cell("A1_MUN"):SetAlign("LEFT")

        oSection1:PrintLine()

        (cAlias)->(dbSkip())

    EndDo

    oSection1:Finish()

Return

Static Function fGetData(cAlias as character)

    Local lRet := .T. as logical

    BEGINSQL ALIAS cAlias

        %noParser%

        SELECT TOP 200
            ' ' A1_FILIAL
            ,A1_LOJA
            ,' ' A1_END
            ,A1_COD
            ,A1_NREDUZ
            ,A1_TIPO
            ,A1_EST
            ,A1_MUN
        FROM %table:SA1% SA1
        WHERE SA1.A1_FILIAL = %xFilial:SA1%
            AND SA1.A1_COD BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
            AND SA1.%notDel%
        ORDER BY SA1.R_E_C_N_O_ DESC

    ENDSQL

    DbSelectArea(cAlias)

    (cAlias)->(DbGoTop())

    if (cAlias)->(EOF()) // se for fim de arquivo
        lRet := .F.
    endif

Return lRet
