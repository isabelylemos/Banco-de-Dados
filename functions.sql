create database sistemaVendasLivro;
use sistemaVendasLivro;

create table Autores (
idAutor int primary key auto_increment,
nome varchar(255),
pais varchar (50)
);

create table livros (
idLivro int auto_increment primary key,
titulo varchar (255),
idAutor int,
preco decimal (10, 2),
estoque int default 0,
constraint fk_idAutor foreign key (idAutor) references Autores (idAutor)
);

create table vendas (
idVenda int auto_increment primary key,
idLivro int,
dataVenda date,
quantidade int,
constraint fk_idLivro foreign key (idLivro) references livros (idLivro)
);

alter table vendas add column valorTotal decimal (10, 2);

insert into Autores (nome, pais) values 
('Machado de Assis', 'Brasil'),
('Clarice Lispector', 'Brasil'),
('Jorge Amado', 'Brasil');

insert into livros (titulo, idAutor, preco, estoque) values 
('Dom Casmurro', 1, 34.90, 12),
('A Hora da Estrela', 2, 29.90, 7),
('Capitães de Areia', 3, 39.90, 9);

insert into vendas (idLivro, dataVenda, quantidade, valorTotal) values 
(1, '2024-09-01', 3, 104.78),
(2, '2024-09-02', 2, 59.80),
(3, '2024-09-02', 1, 39.90);

select * from autores;
select * from livros;
select * from vendas;

#Criar Funções
#Mudar Delimitador MySQL
Delimiter //
create function TotalVendas() returns decimal(10, 2)
begin
declare total decimal (10, 2);
select sum(valorTotal) into total from vendas;
return ifnull(total, 0);
end // 
Delimiter ;

#Executar função
select TotalVendas();

#Criar Função  CulculaVenda
delimiter //
create function calculaVenda(ID int, Qtd int) returns decimal (10,2)
begin
-- Declarar variaveis
declare valorTotal decimal(10,2);
declare precoUnit decimal (10,2);

-- Buscar o preço unitario do livro na tabela livros
select preco into precoUnit from livros where livros.idLivro = ID limit 1;

-- verificar se o retorno é nulo
if precoUnit is null then 
return 0;
end if;

-- calcular o valor total do produto
set valorTotal = precoUnit * Qtd;
return valorTotal;  
end // 

select * from livros;
select calculaVenda(3, 3);

# função calcula estoque
delimiter //
create function calculaEstoque(id int, qtd int) returns int
begin
	declare estoqueAtual int;
    declare qtdVenda int;
    declare estoqueAtualizado int;
    
    select estoque into estoqueAtual from livros where idLivro = id;
    set estoqueAtualizado = estoqueAtual - qtd;
    return estoqueAtualizado;
end //
delimiter ;

select calculaEstoque(3,2);

#producere registrar venda
delimiter //
create procedure RegistraVenda (In id int, in qtd int)
begin
declare valorTotal decimal (10,2);

set valorTotal = calculaVenda(id, qtd);
insert into vendas (idLivro, dataVenda, quantidade, valorTotal) values 
(id, curdate(),qtd,valorTotal);
end //
delimiter ;

#executar procedure 
call RegistraVenda (3, 2);

select calculaEstoque (3, 2);
select * from Livros;

Delimiter //
create procedure BaixarEstoque (in id int, in qtd int)
begin 
	declare estoqueAtualizado int;
    
    set estoqueAtualizado = calculaEstoque (id, qtd);
    
    update livros set estoque = estoqueAtualizado where idLivro = id;
end //
delimiter ;

select * from livros;

call BaixarEstoque(2, 5);

# criar trigger
delimiter //
create trigger vender
after insert on vendas
for each row
begin
  call BaixarEstoque(new.idLivro, new.quantidade);
end //
delimiter ;

select * from livros;
select * from vendas;

call RegistraVenda (1,8);