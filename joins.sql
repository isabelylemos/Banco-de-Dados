#criação de bd caso não exista
create database if not exists emptech;
#apontar o banco para o uso
use emptech;
#criação de tabelas
create table if not exists funcionarios(
codFunc int auto_increment primary key,
nomeFunc varchar (255) not null
);

create table if not exists veiculos(
codVeic int auto_increment primary key,
modelo varchar (255) not null,
placas varchar (20) not null,
codFunc int  
);

#inserindo dados nas tabelas
insert into funcionarios(nomeFunc) values 
('João Silva'),
('Maria Oliveira'),
('Pedro Santos'),
('Ana Costa'),
('Lucas Almeida'),
('Fernanda Lima');

insert into veiculos (Modelo, Placas, codFunc) values 
('Fiat Uno','ABC1D23', 1),('Honda Civic','XYZ2E34', 1),
('Toyota Corolla', 'LMN3F45', 2), ('Chevrolet Onix', 'OPQ4G56', 3),
('VW Gol', 'UVW6I78', 5), ('Peugeot 208', 'YZA7J89', null);

#Inner Join 
select funcionarios.nomeFunc as Nome, veiculos.modelo from veiculos 
join funcionarios on veiculos.codFunc = funcionarios.codFunc;

# Equi Join
#usado quando a pk é igual a fk 
select f.nomeFunc as Nome, v.modelo from veiculos v 
join funcionarios f using (codFunc);

#Left Join 
/* retorna todos os campos do lado esquerdo do Join que se relaciona com o lado direito do join, mais os registros que não relacionam com o lado direito e que sejam do lado esquerdo*/
select f.nomeFunc as Nome, v.modelo from veiculos v
left join funcionarios f using (codFunc);

#Rigth Join 
/* retorna todos os campos do lado direito do Join que se relaciona com o lado esquerdo do join, mais os registros que não relacionam com o lado esquerdo e que sejam do lado direito*/
select f.nomeFunc as Nome, v.modelo from veiculos v
right join funcionarios f using (codFunc);

#full join
/*o full join não finciona para mySQL, podem uma solução ára obter o resultado de uma tabela contendo, 
dados que se relacionam ou não do lado esquerdo com o lado direito do join, mais os dados que se relacionam ou não do lado direito com o lado esquerdo do join,
é necessario que seja feito as query Left join e Rigth Join, porem utulizando UNION para unir as 2 querys e realizar a pesquisa*/
select f.nomeFunc as Nome, v.modelo from veiculos v
left join funcionarios f using (codFunc)
union
select f.nomeFunc as Nome, v.modelo from veiculos v
right join funcionarios f using (codFunc);

/*view - estrutura de seleção que encapsula as querys complexas para simplificar o uso ao usuario e facilitar as chamadas em aplicações externas*/
create view func_veic as
select f.nomeFunc as Nome, v.modelo from veiculos v
left join funcionarios f using (codFunc)
union 
select f.nomeFunc as Nome, v.modelo from veiculos v
right join funcionarios f using (codFunc);

#chamando view 
select * from func_veic;

create table atuacaoVendas(
codAtuacao int auto_increment primary key,
descricao varchar (255) not null
);

insert into atuacaoVendas (descricao) values 
('Vendas de Veiculos Novos'), ('Vendas de Veiculos Usados'),
('Manutenção e Reparo de Veiculos'), ('Serviços de Pós-Vendas'),
('Consultoria de Venda'), ('Programações e eventos especiais');

#Cross join
/*este join ira criar relatorio onde ira fazer todas as combinações possiveis entre as tabelas
Ex: se cruzarmos as Tabelas Funcionarios, veiculos e atuacaoVendas onde teremos Tabela Funcionarios com 6 registros, tabela veiculos com 7 registros e tabela atuacaoVendas com 6 registros, 
teremos um resultado de combinação 6x7x6 que totalizara 252 combinações.*/

select f.codFunc, f.nomeFunc, v.modelo, v.placas, a.descricao from funcionarios f
cross join veiculos v
cross join atuacaoVendas a;

create table indicacoes(
codIndicador int,
codIndicado int,
primary key (codIndicador, CodIndicado),
foreign key (codIndicador) references Funcionarios (codFunc),
foreign key (codIndicado) references Funcionarios (codFunc)
);

insert into indicacoes (codIndicador, codIndicado) values
(1,2),(1,3),(2,4),(2,5),(4,6);

#Self join
/*gera um resultado de relacionamento de dados de uma tabela com ela mesma, ou seja, um auto-relacionamento*/

select i1.codIndicador as 'ID Indicador', f1.nomeFunc as 'Nome Indicador',
i1.codIndicado as 'ID Indicado', f2.nomeFunc as 'Nome Indicado' from indicacoes i1
join funcionarios f1 on i1.codIndicador = f1.codFunc
join funcionarios f2 on i1.codIndicador = f2.codFunc;

