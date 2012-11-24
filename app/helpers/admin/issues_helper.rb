module Admin::IssuesHelper
  def vote_options_for(vote, connection)
    if connection
      selected = connection.matches? ? 'for' : 'against'
    else
      selected = 'unrelated'
    end

    options_for_select(
      {
        t('app.for') => 'for',
        t('app.against') => 'against',
        t('app.unrelated') => 'unrelated'
      },
      selected
    )
  end

  def weight_options_for(connection)
    weight_options = {}

    VoteConnection::WEIGHTS.each do |weight|
      weight_options["%g" % weight] = weight
    end

    selected = (connection && connection.weight) || VoteConnection::DEFAULT_WEIGHT

    options_for_select weight_options, selected
  end

  def topic_options_for(issue)
    topics = {}

    Topic.order(:name).each do |topic|
      topics[topic.name] = topic.id
    end

    options_for_select(topics, issue.topic_ids)
  end

  def editor_options_for(issue)
    users = User.order(:name)

    editor = issue.new_record? ? current_user : issue.editor

    options_from_collection_for_select(users, 'id', 'name', selected: editor.try(:id))
  end

  def proposition_type_options_for(vote)
    types  = I18n.t('app.votes.proposition_types').except(:none)
    sorted = types.invert.sort_by { |human_name, key| human_name }

    sorted.unshift [I18n.t!("app.votes.proposition_types.none"), nil]

    options_for_select sorted, vote.proposition_type
  end

  def connected_issues_for(vote)
    (vote.issues - [@issue]).first(3)
  end

  def promise_status_for(promise)
    conn = promise.promise_connections.find { |pc| pc.issue_id == @issue.id }
    conn ? conn.status : 'unrelated'
  end

  def promise_states
    [PromiseConnection::STATES, PromiseConnection::UNRELATED_STATE].flatten
  end

  def issues_for_promise(promise)
    pcs = promise.promise_connections.select { |e| e.id != @issue.id }

    out = ''

    if pcs.any?
      out = "#{I18n.t 'app.issues.edit.promise_used_in'} "
      out << pcs.map { |pc| link_to(pc.issue.title, pc.issue, target: '_blank') }.to_sentence
    end

    out.html_safe
  end
end