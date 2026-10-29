CREATE PROCEDURE sp_quadro_de_filas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        u.nome_unidade AS Unidade,
        c.nivel_urgencia AS NivelUrgencia,
        COUNT(a.id_atendimento) AS PacientesAguardando,
        -- Calcula o tempo decorrido da chegada até o momento da consulta
        ISNULL(AVG(DATEDIFF(MINUTE, a.data_hora_chegada, GETDATE())), 0) AS TempoEsperaMedioMinutos
    FROM UNIDADE u
    -- Filtra apenas os atendimentos que ainda não foram finalizados
    INNER JOIN ATENDIMENTO a ON u.id_unidade = a.id_unidade AND a.data_hora_fim IS NULL
    INNER JOIN CLASSIFICACAO c ON a.id_classificacao = c.id_classificacao
    GROUP BY 
        u.nome_unidade, 
        c.nivel_urgencia
    ORDER BY 
        u.nome_unidade, 
        PacientesAguardando DESC;
END;
GO

CREATE PROCEDURE sp_atlas_e_cubos
AS
BEGIN
    SET NOCOUNT ON;

    WITH IndicadoresSetor AS (
        SELECT 
            u.id_unidade,
            u.nome_unidade AS Unidade,
            s.nome_setor AS Setor,
            COUNT(m.id_movimentacao) AS VolumeDiario
        FROM UNIDADE u
        JOIN ATENDIMENTO a ON u.id_unidade = a.id_unidade
        JOIN MOVIMENTACAO m ON a.id_atendimento = m.id_atendimento
        JOIN SETOR s ON m.id_setor = s.id_setor
        -- Filtra as movimentações para exibir apenas o tráfego de hoje
        WHERE CAST(m.data_hora_entrada AS DATE) = CAST(GETDATE() AS DATE)
        GROUP BY 
            u.id_unidade, 
            u.nome_unidade, 
            s.nome_setor
    )
    SELECT 
        Unidade,
        Setor,
        VolumeDiario,
        -- O PARTITION BY reseta o ranking (1, 2, 3...) para cada nova Unidade
        ROW_NUMBER() OVER(PARTITION BY id_unidade ORDER BY VolumeDiario DESC) AS RankingMovimento
    FROM IndicadoresSetor
    ORDER BY 
        Unidade, 
        RankingMovimento;
END;
GO
