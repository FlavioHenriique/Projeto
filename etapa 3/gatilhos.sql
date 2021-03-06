1- Designar o controle de 100 unidades da mercadoria de c�digo '004'
para cada novo estoquista na empresa.

CREATE FUNCTION ControlarMercadoria()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO CONTROLA_MERCADORIA(CPFEstoquista,CodMercadoria,Quantidade)
    VALUES(NEW.CPF,'004',100);
    RETURN NULL;
END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER NovoEstoquista
AFTER INSERT ON ESTOQUISTA
FOR EACH ROW
EXECUTE PROCEDURE ControlarMercadoria();

2- Ao remover um caminh�o, devem ser apagados os registros de uso do mesmo.	

CREATE FUNCTION RemoveCaminhao()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM USA_CAMINHAO WHERE PlacaCaminhao=OLD.Placa;
    RETURN OLD;
END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER ExcluirCaminhao
BEFORE DELETE ON CAMINHAO
FOR EACH ROW
EXECUTE PROCEDURE RemoveCaminhao();

3- Quando for adicionado um novo cliente, o vendedor com CPF '66177255409'
deve passar a trabalhar tamb�m na cidade do cliente novo, caso ele n�o esteja
registrado l�.

CREATE FUNCTION CidadeCliente()
RETURNS TRIGGER AS $$
DECLARE
	cont INTEGER:=0;
BEGIN
	SELECT INTO cont COUNT(*)
    FROM CIDADES_VENDEDOR
    WHERE CPFVendedor='66177255409' AND NEW.Cidade=Cidade;
    IF cont<=0 THEN
    INSERT INTO CIDADES_VENDEDOR(CPFVendedor,Cidade)
    VALUES('66177255409',NEW.Cidade);
    END IF;
    RETURN NULL;
END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER NovoCliente
AFTER INSERT ON CLIENTE
FOR EACH ROW
EXECUTE PROCEDURE CidadeCliente();
