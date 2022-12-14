
SELECT DISTINCT
LTRIM (RTRIM (V.CPFCGC_PES)), T.COD_CRED, FILI.NOME_FILI
FROM
_SOMA_PARC S WITH(NOLOCK)
INNER JOIN TITULOS T WITH(NOLOCK) ON T.COD_TIT = S.COD_TIT
AND T.COD_CRED = 50 -- CODIGO DO CREDOR
INNER JOIN V_DEVEDORES V WITH(NOLOCK) ON V.COD_DEV = T.COD_DEV
INNER JOIN FILIAIS FILI WITH(NOLOCK)  ON FILI.CODIGO_FILI = T.COD_FILI
WHERE FILI.NOME_FILI LIKE '%NXT_25_40%' AND V.CPFCGC_PES NOT IN	()