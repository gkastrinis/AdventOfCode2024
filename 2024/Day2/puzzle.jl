module AoC_24_Day2

run_actual(path::String) = solve(read(path, String))

function run_example1()
    input = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
    """
    return solve(input)
end

function prepare_input(input::String)
    lines = filter(line -> !isempty(lstrip(line)), split(input, "\n"))
    reports = Vector{Vector{Int}}(undef, length(lines))
    for (i, line) in enumerate(lines)
        parts = split(line; keepempty=false)
        reports[i] = map(part -> parse(Int, part), parts)
    end
    return reports
end

function solve(input::String)
    reports = prepare_input(input)
    printstyled("Part 1: ", part1(reports), "\n"; color=:yellow)
    printstyled("Part 2: ", part2(reports), "\n"; color=:blue)
    return nothing
end

function is_safe_report(report::Vector{Int})
    sign = (report[2] - report[1]) > 0 ? 1 : -1
    prev = report[1]
    is_safe = true
    for num in (@view report[2:end])
        diff = num - prev
        if diff * sign <= 0 || abs(diff) > 3
            is_safe = false
            break
        end
        prev = num
    end
    return is_safe
end

function part1(reports::Vector{Vector{Int}})
    safe_count = 0
    for report in reports
        is_safe = is_safe_report(report)
        is_safe && (safe_count += 1)
    end
    return safe_count
end

function part2(reports::Vector{Vector{Int}})
    safe_count = 0
    for report in reports
        if is_safe_report(report)
            safe_count += 1
            continue
        end
        # Part 2: tolerance
        len = length(report)
        for i in 1:len
            alternative = vcat(report[1:i-1], report[i+1:len])
            if is_safe_report(alternative)
                safe_count += 1
                break
            end
        end
    end
    return safe_count
end

end
