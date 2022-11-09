/*
Sem usar junção desnecessária, exiba os cods dos Eventos 
que publicaram mais de 10 artigos em inglês com a nota 
acima da média do evento
*/

SELECT A.cod
FROM Artigo A
WHERE A.idioma = 'ingles' AND A.nota >
    (SELECT AVG(A2.nota)
    FROM Artigo A2
    WHERE A.COD = A2.COD)
GROUP BY A.cod
HAVING COUNT(*) > 10;

/*
Sem usar junção desnecessária, exibir os cpfs dos pesquisadores 
que publicaram a mesma quantidade de artigos do pesquisador mais produtivo
*/

SELECT E1.cpf
FROM Escreve E1
GROUP BY E1.cpf
HAVING COUNT(*) = (
    SELECT MAX(qtd)
    FROM (
    	SELECT E2.cpf, COUNT(*) as qtd
        FROM Escreve E2
        GROUP BY E2.cpf
    )
);

/*
Sem usar junção desnecessária, exibir as instituições que têm mais de 5 
pesquisadoras que já publicaram em eventos
*/

SELECT P.instituicao
FROM Pesquisador P
WHERE P.cpf IN (
    SELECT E.cpf
    FROM Escreve E
    WHERE EXISTS (
        SELECT A.mat 
        FROM Artigo A
        WHERE A.cod IS NOT NULL
        AND A.mat = E.mat
    )
) AND P.sex = 'F'
GROUP BY P.instituicao
HAVING COUNT(*) > 5;

/*
Sem usar junção desnecessária, exiba todos os títulos dos artigos publicados 
em qualquer evento que tenha SBBD em sua sigla
*/

SELECT A.titulo
FROM Artigo A 
WHERE A.cod IS NOT NULL AND A.cod IN (
    SELECT E.cod
    FROM Evento E
    WHERE E.sigla LIKE '%SBBD%'
);

-- mais eficiente porque usa EXISTS ao invés de IN:

SELECT A.titulo
FROM Artigo A 
WHERE A.cod IS NOT NULL AND EXISTS (
    SELECT E.cod
    FROM Evento E
    WHERE E.sigla LIKE '%SBBD%'
    AND A.cod = E.cod
);

/*
Sem usar junção desnecessária ou operador IN, exiba o nome dos Pesquisadores 
que já escreveram ao menos 1 artigo
*/

SELECT P.nome 
FROM Pesquisador P
WHERE EXISTS (
    SELECT E.cpf
    FROM Escreve E
    WHERE E.cpf = P.cpf
);

/*
Sem usar join, subconsultas ou condições desnecessárias,
exiba o CPF dos Pesquisadores que são da UFPE e que
publicaram ao menos 2 Artigos cujo código é '1234'.
*/

/* Fiz usando 2 inner joins, mas daria para fazer com 2 subconsultas também */
SELECT P.CPF
FROM PESQUISADOR P INNER JOIN ESCREVE E ON P.CPF = E.CPF
                   INNER JOIN ARTIGO A ON E.MAT = A.MAT
WHERE P.INSTITUICAO = 'ufpe' AND A.COD = '1234'
GROUP BY P.CPF
HAVING COUNT(*) > 1;

-----------------------
