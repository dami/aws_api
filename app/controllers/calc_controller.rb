class CalcController < ApplicationController
    def calculation
        path=request.fullpath
        calc=path.split("?")[1]
        if calc !~ /[^\d+\-\/()*]+/ && calc.present?
          begin
            calc = eval(calc)
            render plain: "#{calc}\n"
          rescue SyntaxError
            render plain: "ERROR\n"
          end
        else
          render plain: "ERROR\n"
        end
    end
end

