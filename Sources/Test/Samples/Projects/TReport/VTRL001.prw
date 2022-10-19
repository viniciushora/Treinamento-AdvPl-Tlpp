#include "rwmake.ch"
#include "protheus.ch"

#define DMPAPER_A4 9

User Function VTRL001()

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

    cPerg := "VTRL001"

    Pergunte(cPerg,.T.) // inicializa as variáveis públicas da pergunta

    cAlias := GetNextAlias()

    cTitulo := "[VTRL001] - Impress�o de Produtos"

    oReport := TReport():New('VTRL001', cTitulo, cPerg, {|oReport| PrintReport(oReport,cAlias)},"Este relatorio ira imprimir a relacao de produtos.")
    oReport:SetPortrait()
    oReport:SetTotalInLine(.F.)
    oReport:ShowHeader()

    oSection1 := TRSection():New(oReport,"Filial",{cAlias})
    oSection1:SetTotalInLine(.F.)

    TRCell():New( oSection1, "B1_FILIAL" , cAlias, 'FILIAL'    ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "B1_CODMES" , cAlias, 'COD.MES'   ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "B1_SUFIXO" , cAlias, 'SUFIXO'    ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "B1_COD"    , cAlias, 'COD.INT'   , PesqPict('SB1',"B1_COD"), 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "B1_REFFAB" , cAlias, 'REF.FAB'   ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "B1_DESC"   , cAlias, 'DESCRIÇÃO' ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "Z5_ABREV"  , cAlias, 'ABREVI'    ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "B1_TIPO"   , cAlias, 'TIPO'      ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "BM_DESC"   , cAlias, 'GRUPO'     ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )
    TRCell():new( oSection1, "VE1_DESMAR", cAlias, 'MARCA'     ,                         , 50, /*lPixel*/, /*{|| code-block de impressao }*/ )

    oBreak := TRBreak():New(oSection1,oSection1:Cell("B1_FILIAL"),,.F.)

    TRFunction():New(oSection1:Cell("B1_FILIAL"),"TOTAL FILIAL","COUNT",oBreak,,"@E 999999",,.F.,.F.)

    TRFunction():New(oSection1:Cell("B1_FILIAL"),"TOTAL GERAL" ,"COUNT",,,"@E 999999",,.F.,.T.)

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

    While !(cAlias)->(EOF()) // (cAlias)->(!EOF())

        If oReport:Cancel()
            Exit
        EndIf

        oReport:IncMeter()

        oSection1:Cell("B1_FILIAL"):SetValue((cAlias)->B1_FILIAL)
        oSection1:Cell("B1_FILIAL"):SetAlign("CENTER")

        oSection1:Cell("B1_CODMES"):SetValue((cAlias)->B1_CODMES)
        oSection1:Cell("B1_CODMES"):SetAlign("CENTER")

        oSection1:Cell("B1_SUFIXO"):SetValue((cAlias)->B1_SUFIXO)
        oSection1:Cell("B1_SUFIXO"):SetAlign("CENTER")

        oSection1:Cell("B1_COD"):SetValue((cAlias)->B1_COD)
        oSection1:Cell("B1_COD"):SetAlign("CENTER")

        oSection1:Cell("B1_REFFAB"):SetValue((cAlias)->B1_REFFAB)
        oSection1:Cell("B1_REFFAB"):SetAlign("LEFT")

        oSection1:Cell("B1_DESC"):SetValue((cAlias)->B1_DESC)
        oSection1:Cell("B1_DESC"):SetAlign("LEFT")

        // oSection1:Cell("Z5_ABREV"):SetValue(Posicione("SZ5",1,xFilial("SZ5")+(cAlias)->B1_GRUFAM,"Z5_ABREV"))
        // oSection1:Cell("Z5_ABREV"):SetAlign("LEFT")

        oSection1:Cell("B1_TIPO"):SetValue((cAlias)->B1_TIPO)
        oSection1:Cell("B1_TIPO"):SetAlign("LEFT")

        oSection1:Cell("BM_DESC"):SetValue(Posicione("SBM",1,xFilial("SBM")+(cAlias)->B1_GRUPO,"BM_DESC"))
        oSection1:Cell("BM_DESC"):SetAlign("LEFT")

        // oSection1:Cell("VE1_DESMAR"):SetValue(Posicione("VE1",2,xFilial("VE1")+(cAlias)->B1_ABREVI,"VE1_DESMAR"))
        // oSection1:Cell("VE1_DESMAR"):SetAlign("LEFT")

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
            ' ' B1_FILIAL
            ,' ' B1_CODMES
            ,' ' B1_SUFIXO
            ,B1_COD
            ,' ' B1_REFFAB
            ,B1_DESC
            ,' ' Z5_ABREV
            ,B1_TIPO
            ,'0001 ' B1_GRUPO
            ,'GRUPO PADR�O ' BM_DESC
            ,' ' VE1_DESMAR
        FROM %table:SB1% SB1
        WHERE SB1.B1_FILIAL = %xFilial:SB1%
            AND SB1.B1_COD BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
            AND SB1.%notDel%
        ORDER BY SB1.R_E_C_N_O_ DESC

    ENDSQL

    DbSelectArea(cAlias)

    (cAlias)->(DbGoTop())

    if (cAlias)->(EOF()) // se for fim de arquivo
        lRet := .F.
    endif

Return lRet
