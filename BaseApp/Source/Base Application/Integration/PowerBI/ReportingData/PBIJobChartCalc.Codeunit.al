// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Integration.PowerBI;

using Microsoft.Projects.Project.Analysis;
using Microsoft.Projects.Project.Job;

codeunit 6308 "PBI Job Chart Calc."
{

    trigger OnRun()
    begin
    end;

    var
        Job: Record Job;
        TotalRevenueTxt: Label 'Total Revenue';
        TotalCostTxt: Label 'Total Cost';
        ProfitMarginTxt: Label 'Profit Margin';
        ActualTotalCostTxt: Label 'Actual Total Cost';
        BudgetTotalCostTxt: Label 'Budget Total Cost';
        CostVarianceTxt: Label 'Cost Variance';
        ActualTotalPriceTxt: Label 'Actual Total Price';
        BudgetTotalPriceTxt: Label 'Budget Total Price';
        PriceVarianceTxt: Label 'Price Variance';
        JobChartType: Option Profitability,"Actual to Budget Cost","Actual to Budget Price";

    procedure GetValues(var TempPowerBIChartBuffer: Record "Power BI Chart Buffer" temporary; pJobChartType: Option Profitability,"Actual to Budget Cost","Actual to Budget Price")
    var
        MyJob: Record "My Job";
    begin
        JobChartType := pJobChartType;

        with MyJob do begin
            SetRange("User ID", UserId);
            SetRange("Exclude from Business Chart", false);
            if FindSet() then
                repeat
                    if Job.Get("Job No.") then
                        CalculateValues(TempPowerBIChartBuffer);
                until Next() = 0;
        end;
    end;

    local procedure CalculateValues(var TempPowerBIChartBuffer: Record "Power BI Chart Buffer" temporary)
    var
        JobChartMgt: Codeunit "Job Chart Mgt";
        ActualCost: Decimal;
        BudgetCost: Decimal;
        CostVariance: Decimal;
        JobRevenue: Decimal;
        JobCost: Decimal;
        ProfitMargin: Decimal;
        ActualPrice: Decimal;
        BudgetPrice: Decimal;
        PriceVariance: Decimal;
    begin
        case JobChartType of
            JobChartType::Profitability:
                begin
                    JobChartMgt.CalculateJobRevenueAndCost(Job, JobRevenue, JobCost);
                    ProfitMargin := JobRevenue - JobCost;
                    InsertToBuffer(TempPowerBIChartBuffer, JobRevenue, TotalRevenueTxt);
                    InsertToBuffer(TempPowerBIChartBuffer, JobCost, TotalCostTxt);
                    InsertToBuffer(TempPowerBIChartBuffer, ProfitMargin, ProfitMarginTxt);
                end;
            JobChartType::"Actual to Budget Cost":
                begin
                    JobChartMgt.CalculateJobCosts(Job, ActualCost, BudgetCost);
                    CostVariance := BudgetCost - ActualCost;
                    InsertToBuffer(TempPowerBIChartBuffer, ActualCost, ActualTotalCostTxt);
                    InsertToBuffer(TempPowerBIChartBuffer, BudgetCost, BudgetTotalCostTxt);
                    InsertToBuffer(TempPowerBIChartBuffer, CostVariance, CostVarianceTxt);
                end;
            JobChartType::"Actual to Budget Price":
                begin
                    JobChartMgt.CalculateJobPrices(Job, ActualPrice, BudgetPrice);
                    PriceVariance := BudgetPrice - ActualPrice;
                    InsertToBuffer(TempPowerBIChartBuffer, ActualPrice, ActualTotalPriceTxt);
                    InsertToBuffer(TempPowerBIChartBuffer, BudgetPrice, BudgetTotalPriceTxt);
                    InsertToBuffer(TempPowerBIChartBuffer, PriceVariance, PriceVarianceTxt);
                end;
        end;
    end;

    local procedure InsertToBuffer(var TempPowerBIChartBuffer: Record "Power BI Chart Buffer" temporary; pValue: Decimal; pMeasureName: Text[111])
    begin
        with TempPowerBIChartBuffer do begin
            if FindLast() then
                ID += 1
            else
                ID := 1;
            Value := pValue;
            "Measure Name" := pMeasureName;
            "Measure No." := Job."No.";
            Insert();
        end;
    end;
}

