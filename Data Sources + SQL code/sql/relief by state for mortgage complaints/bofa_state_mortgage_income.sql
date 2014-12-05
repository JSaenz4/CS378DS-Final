drop table bofa_state_mortgage_income;
create table bofa_state_mortgage_income (
state_abbr varchar(2),
state varchar(30),
relief NUMBER,
total NUMBER,
percent_relief NUMBER,
income NUMBER,
home_price NUMBER,
home_price_to_income NUMBER
);

insert into bofa_state_mortgage_income select * from ( 



select state_data.*, state_home_price.average as home_price, (state_home_price.average/income) as mortgage_to_income from
(select total.state state_abbr, state_income_2011_2013.states state, nvl(relief_complaints, 0) relief_complaints, total_complaints, 
  nvl((relief_complaints/total_complaints), 0) percent_relief,
  (median_income) as income from 
(select state, count(complaint_id) total_complaints from complaindata 
  where ( company in (
      --'Wells Fargo'--,
      --'JPMorgan Chase'--,
      --'Citibank'--,
      'Bank of America'--,
      --'Ocwen'--,
      --'Nationstar Mortgage'
    ) and
    state in (
     'AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'HI',
     'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN',
     'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH',
     'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA',
     'WI', 'WV', 'WY'
    )
    and
    product in ('Mortgage')
  ) group by state) total 

left join


(select state, count(complaint_id) relief_complaints from complaindata 
  where ( company in (
      --'Wells Fargo'--,
      --'JPMorgan Chase'--,
      --'Citibank'--,
      'Bank of America'--,
      --'Ocwen'--,
      --'Nationstar Mortgage'--
    ) 
    and
    state in (
     'AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'HI',
     'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN',
     'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH',
     'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA',
     'WI', 'WV', 'WY'
    )
    and
    product in ('Mortgage')
    and company_response in (
      'Closed with monetary relief', 'Closed with non-monetary relief')
    ) group by state) relief
on relief.state = total.state 
left join state_income_2011_2013 on state_income_2011_2013.state_abbr = total.state) state_data
left join state_home_price on state_data.state = state_home_price.state
order by state_home_price.state);