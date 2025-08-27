alter procedure
	customerSummary @Country nvarchar(50) = 'USA'
	as
	begin
	--========================
	--try and catch (try block)
	--========================
		begin try

		--===================
		--declaring variables
		--===================
			declare @totalCustomers int, @avgScore float

		--===================
		--prepare and cleanup
		--===================
			if exists (select 1 from sales.Customers where score is null and country = @country)
			begin
				print ('updating null scores to 0');
				update sales.Customers
				set score = 0
				where score is null and country = @Country
			end

			else
			begin
				print('no null scores found')
			end;


		--==================
		--generating reports
		--==================
				select 
					@totalCustomers = count(*),
					@avgScore       = avg(score)
				from sales.Customers
				where country = @Country;

			print 'Total Customers from ' + @country + ' :' + cast(@totalCustomers as nvarchar);
			print 'Average score from '   + @country + ' :' + cast(@avgScore as nvarchar);

			--===================
			--generating summary
			--===================
				select
					count(orderid) totalOrders,
					sum(sales) totalSales
				from sales.Orders as o
				join sales.Customers as c
				on c.CustomerID = o.CustomerID
				where c.Country = @Country

		end try

	--===========
	--catch block
	--===========
		begin catch
			print ('an error occured');
			print('error message :' +error_message());
			print('error number :' + cast(error_number() as nvarchar));
			print('error line :' + cast(error_line() as nvarchar));
			print('error procedure :' + error_procedure());
		end catch
	end;


exec customerSummary @country =  'Germany'
