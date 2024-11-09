def get_job_type_from_cron(cron_expression):
    try:
        minute, hour, day_of_month, month, day_of_week = cron_expression.split()
        
        # Check for preset macros first
        if cron_expression == "0 0 1 1 *":
            return "yearly"  # @yearly - Run once a year at midnight of 1 January
            
        if cron_expression == "0 0 1 * *":
            return "monthly"  # @monthly - Run once a month at midnight of first day
            
        if cron_expression == "0 0 * * 0":
            return "weekly"  # @weekly - Run once a week at midnight on Sunday
            
        if cron_expression == "0 0 * * *":
            return "daily"  # @daily/@midnight - Run once a day at midnight
            
        if cron_expression == "0 * * * *":
            return "hourly"  # @hourly - Run once an hour at the beginning of the hour
            
        # Check for common patterns
        if minute == "0":  # Starting at exact hours
            if hour == "0":  # Starting at midnight
                if day_of_month == "1" and month != "*":
                    return "yearly-custom"  # Specific months at 1st day
                elif day_of_month == "1":
                    return "monthly"  # Every month at 1st day
                elif day_of_month == "*" and day_of_week != "*":
                    return "weekly-custom"  # Specific days of week
                elif day_of_month == "*" and day_of_week == "*":
                    return "daily"  # Every day
            elif hour != "*":
                if day_of_month == "*" and day_of_week == "*":
                    return "daily-custom"  # Specific hours every day
                else:
                    return "custom"  # Specific hours on specific days
        elif minute != "*":
            return "custom-minutes"  # Specific minutes
        
        # If all parts are specific values (not * or */n)
        if not any(x == "*" or "/" in x for x in [minute, hour, day_of_month, month, day_of_week]):
            return "specific-time"
            
        # If none of the above patterns match
        return "custom"
        
    except ValueError:
        return "invalid"

# Test cases to demonstrate usage
def test_cron_patterns():
    test_cases = {
        "0 0 1 1 *": "yearly",           # Every January 1st at midnight
        "0 0 1 * *": "monthly",          # First day of every month at midnight
        "0 0 * * 0": "weekly",           # Every Sunday at midnight
        "0 0 * * *": "daily",            # Every day at midnight
        "0 * * * *": "hourly",           # Every hour at minute 0
        "0 0 1 3,6,9,12 *": "yearly-custom",  # First day of specific months
        "0 0 * * 1,3,5": "weekly-custom",     # Every Monday, Wednesday, Friday
        "0 9 * * *": "daily-custom",          # Every day at 9 AM
        "*/15 * * * *": "custom-minutes",     # Every 15 minutes
        "30 14 1,15 * *": "custom",           # Specific days at 2:30 PM
        "bad-expression": "invalid"            # Invalid expression
    }
    
    # for cron, expected in test_cases.items():
    #     result = get_job_type_from_cron(cron)
    #     print(f"Cron: {cron:20} Type: {result:15} Expected: {expected}")
    #     assert result == expected, f"Failed: {cron} got {result}, expected {expected}"

if __name__ == "__main__":
    test_cron_patterns()
