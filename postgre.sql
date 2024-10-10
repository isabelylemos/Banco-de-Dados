-- criar banco de dados
create database nomeBanco;

-- criar tabela
create table tipoProdutos(
	idProd serial primary key, --serial = int e auto increment
	descricao varchar (100)
); 

create table produtos(
	idProduto serial primary key,
	descricao varchar (100) not null,
	preco money not null, -- tipo de dado exclusivo para moeda
	id_tipo_produto int references tipoProdutos(idProd) -- criação de foreign key
);

/*inserindo dados na tabela*/
insert into tipoProdutos (descricao) values
('computadores'), ('impressora');

/*toda inserção de valores tipo texto usar aspas simples*/


insert into produtos (descricao, preco, id_tipo_produto) values
('desktop', 1200.00, 1),
('laptop', 3200.00, 1),
('impressora jato de tinta', 500.00,2), 
('impressora laser', 1200.00, 2);

--listagem de dados
--listar todos os registros da tabela
select * from produtos;

-- listar os produtos em ordem decrescente por descrição
select * from produtos order by descricao desc;

-- listar os produtos em ordem crescente de preço
select * from produtos order by preco asc;

-- listar os produtos que são do tipo 2
select * from produtos where id_tipo_produto = 2;

--listar os produtos que são do tipo de produto computador
select p.idProduto, p.descricao, p.preco, tp.descricao from produtos 
p left join tipoProdutos tp on p.id_tipo_produto = tp.idProd 
where tp.descricao = 'computadores';

-- retorne o valor total de cada tipo de produto 
-- tipo de produto
