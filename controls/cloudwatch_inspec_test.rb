control 'cloudwatch_log_group_tests' do
    title 'Compliance tests for AWS cloudwatch log groups'
    cloudwatch_log_groups = input('cloudwatch_log_groups')

    cloudwatch_log_groups.each do |cloudwatch_log_group|

        log_group_name = cloudwatch_log_group['name']
        tags = cloudwatch_log_group['tags']

        # Ensure that an aws_cloudwatch_log_group exists
        describe aws_cloudwatch_log_group(log_group_name) do
            it { should exist }
        end

        tags.each do |tag|
            tag_name = tag['tag_name']
            tag_value = tag['tag_value']
            # Test tags on the CloudWatch Log Group
            describe aws_cloudwatch_log_group(log_group_name) do
                its('tags') { should include(tag_name => tag_value)}
            end
        end
    end
end    

control 'cloudwatch-log-metric-filter-test' do
    title 'Compliance tests for AWS aws cloudwatch log metric filter'

    cloudwatch_metric_filter = input('cloudwatch_metric_filter_details')

    cloudwatch_metric_filter.each do |cloudwatch_metric|

        filter_name = cloudwatch_metric['filter_name']
        log_group_name = cloudwatch_metric['log_group_name']
        pattern = cloudwatch_metric['pattern']
                
        # Ensure that CloudWatch Log  metric filter exists
        describe aws_cloudwatch_log_metric_filter(filter_name: filter_name, log_group_name: log_group_name) do
            it { should exist }
        end

        # Ensure a Filter exists for a specific pattern
        describe aws_cloudwatch_log_metric_filter(pattern: pattern) do
            it { should exist }
        end

        #   Check the name of a Filter
        describe aws_cloudwatch_log_metric_filter(log_group_name: log_group_name, pattern: pattern) do
            its('filter_name') { should eq filter_name }
        end

        #   Check the Log Group name of a Filter
        describe aws_cloudwatch_log_metric_filter(filter_name: filter_name) do
            its('log_group_name') { should eq log_group_name }
        end

        #   Check a filter has the correct pattern
        describe aws_cloudwatch_log_metric_filter(filter_name: filter_name, log_group_name: log_group_name) do
            its('pattern') { should cmp pattern }
        end
    
    end
end