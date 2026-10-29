# G1---Trabalho-de-Banco-de-Dados-UPA-Monitor
Grupo 16: Celso, José, Winnicius
```mermaid
erDiagram
    UNIDADE ||--o{ ATENDIMENTO : hospeda
    PACIENTE ||--o{ ATENDIMENTO : realiza
    CLASSIFICACAO ||--o{ ATENDIMENTO : classifica
    ATENDIMENTO ||--o{ MOVIMENTACAO : registra
    SETOR ||--o{ MOVIMENTACAO : recebe
    UNIDADE ||--o{ SETOR : possui
    UNIDADE ||--o{ HISTORICO_MONITORAMENTO : registra
    ATENDIMENTO ||--o{ HISTORICO_STATUS : possui

    UNIDADE {
        int id_unidade PK
        string nome_unidade UK
        string cnes UK
        boolean is_operacional
        string status_conexao
        timestamp ultima_atualizacao
    }

    PACIENTE {
        int id_paciente PK
        string cpf UK
        string nome_completo
        date data_nascimento
    }

    CLASSIFICACAO {
        int id_classificacao PK
        string cor_pulseira UK
        string nivel_urgencia
        int tempo_alvo_minutos
    }

    ATENDIMENTO {
        int id_atendimento PK
        int id_paciente FK
        int id_unidade FK
        int id_classificacao FK
        timestamp data_hora_chegada
        timestamp data_hora_inicio_triagem
        timestamp data_hora_fim_triagem
        timestamp data_hora_inicio_medico
        timestamp data_hora_fim
        string status_geral
        boolean caso_critico
    }

    SETOR {
        int id_setor PK
        int id_unidade FK
        string nome_setor
        boolean is_fila_espera
        int capacidade_maxima
    }

    MOVIMENTACAO {
        int id_movimentacao PK
        int id_atendimento FK
        int id_setor FK
        timestamp data_hora_entrada
        timestamp data_hora_saida
    }

    HISTORICO_MONITORAMENTO {
        int id_historico PK
        int id_unidade FK
        timestamp data_hora_registro
        int total_aguardando
        int casos_criticos
        int total_atendimentos
        string status_operacional
    }

    HISTORICO_STATUS {
        int id_historico_status PK
        int id_atendimento FK
        string status_anterior
        string status_novo
        timestamp data_hora_alteracao
    }
