CREATE DATABASE cursores_aula
GO
USE cursores_aula
GO
CREATE TABLE curso(
codigo				INT				NOT NULL,
nome				VARCHAR(255)	NOT NULL,
duracao				INT				NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE disciplinas(
codigo				VARCHAR(7)		NOT NULL,
nome				VARCHAR(255)	NOT NULL,
carga_horaria		INT				NOT NULL
PRIMARY KEY(codigo)
)
GO 
CREATE TABLE disciplina_curso(
codigo_disciplina	VARCHAR(7)		NOT NULL,
codigo_curso		INT				NOT NULL
PRIMARY KEY(codigo_disciplina, codigo_curso),
FOREIGN KEY(codigo_disciplina) REFERENCES disciplinas(codigo),
FOREIGN KEY(codigo_curso) REFERENCES curso(codigo)
)

INSERT INTO curso VALUES
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logistica', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600)

INSERT INTO disciplinas VALUES
('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Físico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80)

INSERT INTO disciplina_curso VALUES
('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94)

CREATE FUNCTION fn_info_curso(@codigo INT)
RETURNS @tabela TABLE(
codigo_disciplina			VARCHAR(7),
nome_disciplina				VARCHAR(255),
carga_horaria_disciplina	INT,
nome_curso					VARCHAR(255))
AS
BEGIN
	DECLARE @codigo_disciplina			VARCHAR(7),
			@nome_disciplina			VARCHAR(255),
			@carga_horaria_disciplina	INT,
			@nome_curso					VARCHAR(255)
	SELECT @nome_curso = nome FROM curso WHERE codigo = @codigo
	DECLARE c CURSOR FOR
		SELECT codigo_disciplina FROM disciplina_curso WHERE codigo_curso = @codigo
	OPEN c
	FETCH NEXT FROM c
		INTO @codigo_disciplina
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @nome_disciplina = (SELECT nome FROM disciplinas WHERE codigo = @codigo_disciplina)
		SET @carga_horaria_disciplina = (SELECT carga_horaria FROM disciplinas WHERE codigo = @codigo_disciplina)
		INSERT INTO @tabela VALUES (@codigo_disciplina, @nome_disciplina, @carga_horaria_disciplina, @nome_curso)
		FETCH NEXT FROM c INTO @codigo_disciplina
	END
	CLOSE C
	DEALLOCATE C
	RETURN
END

-- Análise e Desenvolvimento de Sistemas
SELECT * FROM fn_info_curso(48)
-- Logistica
SELECT * FROM fn_info_curso(51)
-- Polímeros
SELECT * FROM fn_info_curso(67)
-- Comércio Exterior
SELECT * FROM fn_info_curso(73)
-- Gestão Empresarial
SELECT * FROM fn_info_curso(94)

-- Código Inexistente
SELECT * FROM fn_info_curso(0)