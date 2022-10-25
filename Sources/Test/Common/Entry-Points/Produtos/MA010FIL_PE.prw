#include "TOTVS.ch"

User Function MA010FIL()

    Local cFiltro := "" as character

    if MsgYesNo("Deseja exibir apenas produtos do tipo Mercadoria?","Atenção!")

        cFiltro := "SB1->B1_TIPO == 'ME' " // mercadoria

    endif

Return cFiltro
