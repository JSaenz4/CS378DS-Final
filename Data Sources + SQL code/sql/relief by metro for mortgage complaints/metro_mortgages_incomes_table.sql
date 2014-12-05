drop table msa_income_mortgage;
create table msa_income_mortgage (
msa_num NUMBER,
msa_name varchar(50),
state varchar(15),
income NUMBER,
home_price NUMBER,
home_price_income_ratio NUMBER
);

insert into msa_income_mortgage select * from ( 

select distinct msa_num, city, incomes.state, med_income_2013, average as
avg_home_price, (average/med_income_2013) as home_price_income_ratio 
from metro_mortgages mortgages, msa_incomes incomes
where instr(lower(incomes.msa_name), lower(mortgages.city))>0
and instr(incomes.state, mortgages.state)>0 order by msa_name
);

commit;








