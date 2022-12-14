USE Cobsystems_Base8

DROP TABLE IF EXISTS #IMP19REMESSA

SELECT  I.COD_CRED,ARQ_IMP, CONVERT(VARCHAR,I.DATA_IMP,20) AS INICIO_IMPORTACAO, CONVERT(VARCHAR,I.DATA_FIM_IMP,20) AS FIM_IMPORTACAO,
	S.DESCRICAO, COUNT(DISTINCT H.COD_TIT) AS CONTRATOS, COUNT (DISTINCT H.COD_PARC) AS PARCELAS
INTO #IMP19REMESSA
FROM VSQL10.COBSYSTEMS_BASE8.DBO.IMPORTACAO_HISTORICO H
	INNER JOIN IMPORTACAO_SITUACAO AS S ON H.COD_SITUACAO = S.COD_SITUACAO
	INNER JOIN IMPORTACAO I ON I.COD_IMP = H.COD_IMP
WHERE I.ARQ_IMP LIKE '%5401%' AND I.DATA_IMP BETWEEN CAST(DATEADD(day,0, GETDATE()) AS DATE) AND CAST(GETDATE()+1 AS DATE) AND I.ARQ_IMP LIKE '%REMESSA%'
GROUP BY I.COD_CRED, I.ARQ_IMP, I.DATA_IMP, I.DATA_FIM_IMP, S.DESCRICAO
ORDER BY I.DATA_IMP DESC 

/* DECLARAÇÃO DAS VARIAVEIS*/
DECLARE
	@ARQMOV AS varchar(MAX), -- ARQUIVO DE MOVIMENTACAO
	@iNICIO AS SMALLDATETIME, --INICIO DA IMPORTACAO
	@FIM AS SMALLDATETIME, -- FIM DA IMPORTACAO
	@ATUALIZACAOCONTRATOS AS INT,--QNT DE ATUALIZACAO POR CONTRATO
	@ATUALIZACAOPARCELAS AS INT,--QNT DE ATUALIZAÇÃO POR PARCELAS
	@IMPORTACAOCONTATOS AS INT , --QNT DE IMPORTACAO POR CONTRATOS
	@IMPORTACAOPARCELAS AS INT,--QNT DE IMPORTACAO POR PARCELAS
	@REABERTURACONTRATOS AS INT, -- QNT DE REABERTURA POR CONTRATO
	@REABERTURAPARCELAS AS INT --QNT DE REABERTURA POR PARCELAS

	
	SET @ARQMOV = (SELECT TOP 1 ARQ_IMP FROM #IMP19REMESSA)
	SET @iNICIO = (SELECT TOP 1 INICIO_IMPORTACAO FROM #IMP19REMESSA)
	SET @FIM = (SELECT TOP 1 FIM_IMPORTACAO FROM #IMP19REMESSA)
	SET @ATUALIZACAOCONTRATOS = (SELECT TOP 1 CONTRATOS FROM #IMP19REMESSA WHERE DESCRICAO LIKE '%Atualização%')
	SET @ATUALIZACAOPARCELAS = (SELECT TOP 1 PARCELAS FROM #IMP19REMESSA WHERE DESCRICAO LIKE '%Atualização%')
	SET @IMPORTACAOCONTATOS = (SELECT TOP 1 CONTRATOS FROM #IMP19REMESSA WHERE DESCRICAO LIKE '%Importação%')
	SET @IMPORTACAOPARCELAS = (SELECT TOP 1 PARCELAS FROM #IMP19REMESSA WHERE DESCRICAO LIKE '%Importação%')
	SET @REABERTURACONTRATOS = (SELECT TOP 1 CONTRATOS FROM #IMP19REMESSA WHERE DESCRICAO LIKE '%Reabertura%')
	SET @REABERTURAPARCELAS = (SELECT TOP 1 PARCELAS FROM #IMP19REMESSA WHERE DESCRICAO LIKE '%Reabertura%')



/*CRIAÇÃO DO DESIGNER DA CONSULTA*/

SELECT 'RESUMO DE IMPORTAÇÃO CREDOR: 019 - TIM SERASA ' + '_

		_ARQUIVO: ' + @ARQMOV + '_

		_INICIO DA IMPORTAÇÃO: ' + FORMAT(@iNICIO,'dd/mm/yyyy hh:mm','PT-BR') + '_ 

		_IMPORTAÇÃO POR CONTRATO: ' + CAST(@IMPORTACAOCONTATOS AS VARCHAR) + '_

		_IMPORTAÇÃO POR PARCELAS: ' + CAST(@IMPORTACAOPARCELAS AS VARCHAR) + '+

		_ATUALIZAÇÃO POR CONTRATO: ' + CAST(@ATUALIZACAOCONTRATOS AS VARCHAR) + '_

		_ATUALIZAÇÃO POR PARCELAS: ' + CAST(@ATUALIZACAOPARCELAS AS VARCHAR) +  '_

		_REABERTURA POR CONTRATOS: ' + CAST(@REABERTURACONTRATOS AS VARCHAR) + '_

		_REABERTURA POR PARCELAS: ' + CAST(@REABERTURAPARCELAS AS VARCHAR) + '_
	   
		_FIM DA IMPORTAÇÃO: ' + FORMAT(@FIM,'dd/mm/yyyy hh:mm','PT-BR') 

