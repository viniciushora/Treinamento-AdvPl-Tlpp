
SELECT *
FROM SX2990 SX2
WHERE SX2.X2_CHAVE = 'SB1'
    ;

SELECT TOP 200 *
FROM SX9990 SX9
WHERE SX9.X9_DOM = 'SBM' -- domínio (tbl. principal)
    AND SX9.X9_CDOM = 'SB1' -- contra domínio (tbl. secundária)
    and SX9.D_E_L_E_T_ = ' '
    ;

SELECT TOP 200
     SB1.B1_FILIAL
    ,SB1.B1_COD
    ,SB1.B1_DESC
    ,SBM.BM_GRUPO
    ,SBM.BM_DESC
FROM SB1990 SB1
LEFT JOIN SBM990 SBM ON SBM.BM_FILIAL = SB1.B1_FILIAL AND SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.D_E_L_E_T_ = ' '
WHERE SB1.B1_FILIAL = ' '
    AND SB1.D_E_L_E_T_ = ' '
    ;



SELECT TOP 200
     B1_FILIAL
    ,' ' B1_CODMES
    ,' ' B1_SUFIXO
    ,B1_COD
    ,' ' B1_REFFAB
    ,B1_DESC
    ,' ' Z5_ABREV
    ,B1_TIPO
    ,'GRUPO PADRAO' BM_DESC
    ,' ' VE1_DESMAR
FROM SB1990 SB1
WHERE SB1.B1_FILIAL = ' '
    AND SB1.D_E_L_E_T_ = ' '
ORDER BY SB1.R_E_C_N_O_ DESC
    ;